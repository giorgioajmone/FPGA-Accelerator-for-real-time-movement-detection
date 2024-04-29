// Giorgio Ajmone 368146, Alessandro Cardinale 368411

module DMAController (
    input wire validInstruction, writeEnable, clock, reset,
    input wire[2:0] configurationBits,
    output wire[31:0] readSettings,
    input wire[31:0] writeSettings,

    //memory ports
    output wire[8:0] memAddress,
    input wire[31:0] memDataIn,
    output wire[31:0] memDataOut,
    output wire memWriteEnable, 

    //bus ports
    input wire[31:0] address_data_in,
    output wire[31:0] address_data_out,
    output wire[3:0] byte_enables_out,
    output wire[7:0] burst_size_out,
    output wire read_n_write_out, begin_transaction_out, end_transaction_out, data_valid_out,
    input wire end_transaction_in, data_valid_in, busy_in, error_in,
    input wire grantRequest,
    output wire busRequest
);

    reg[4:0] state;  
    localparam IDLE = 5'b00000;
    localparam REQUEST = 5'b00010;
    localparam INIT = 5'b00001;
    localparam READ = 5'b10000;
    localparam CLOSE = 5'b01000;
    localparam WRITE = 5'b00100;
    localparam C2R = 5'b11000;
    
    reg[31:0] busStart;
    reg[8:0] memoryStart;
    reg[9:0] blockSize;
    reg[8:0] burstSize;
    reg[1:0] statusRegister;
    reg[1:0] controlRegister;

    reg[31:0] busAddress; 
    reg[8:0] memAddress_r;
    reg[8:0] burstCounter;
    reg[9:0] blockCounter;

    reg[9:0] burstToShow;

    //CPU

    assign readSettings = (validInstruction == 0 || writeEnable == 1) ? 32'b0 : 
                            (configurationBits == 3'b001) ? busStart : 
                                (configurationBits == 3'b010) ? memoryStart : 
                                    (configurationBits == 3'b011) ? blockSize :
                                        (configurationBits == 3'b100) ? burstSize - 9'd1 :
                                            (configurationBits == 3'b101) ? statusRegister : 32'b0; 

    
    always @(posedge clock) begin
        if(reset == 1) begin
            busStart <= 0; 
            memoryStart <= 0; 
            blockSize <= 0;
            burstSize <= 0;
            controlRegister <= 0;
        end else if(state == CLOSE || (state == READ && end_transaction_in == 1'b1 && blockCounter == blockSize)) begin
            controlRegister <= 2'b00;
            busStart <= busStart;
            memoryStart <= memoryStart;
            blockSize <= blockSize;
            burstSize <= burstSize;
        end else if(validInstruction == 1 && writeEnable == 1) begin
            case (configurationBits)
                3'd1: begin  busStart <= writeSettings; end
                3'd2: begin  memoryStart <= writeSettings[8:0]; end
                3'd3: begin  blockSize <= writeSettings[9:0]; end
                3'd4: begin burstSize <= {1'd0, writeSettings[7:0]} + 9'd1; end
                3'd5: begin controlRegister <= writeSettings[1:0]; end
                default: begin end
            endcase
        end
    end

    // MEMORY

    assign memAddress = memAddress_r;
    assign memWriteEnable = (state == READ && data_valid_in == 1'b1) ? 1'b1 : 1'b0;
    assign memDataOut = address_data_in;

    always @(posedge clock) begin
        if(reset == 1) begin 
            memAddress_r <= 9'b0;
        end else if((state == READ && data_valid_in == 1) || (state == WRITE && busy_in == 1'b0)) begin
            memAddress_r <= memAddress_r + 1;
        end else if (state == INIT) begin
            memAddress_r <= memAddress_r;
        end else if (state == IDLE) begin
            memAddress_r <= memoryStart;
        end else begin
            memAddress_r <= memAddress_r;
        end
    end

    // BUS

    assign busRequest = state[1];

    assign begin_transaction_out = state[0];
    assign read_n_write_out = state[0] & controlRegister[0];
    assign address_data_out = (state == INIT) ? busAddress : (state == WRITE) ? {memDataIn[7:0], memDataIn[15:8], memDataIn[23:16], memDataIn[31:24]}: 32'b0; 
    //(busAddress & state[0]) | ({memDataIn[7:0], memDataIn[15:8], memDataIn[23:16], memDataIn[31:24]} & state[2]);
    
    assign burst_size_out = burstToShow[7:0];
    assign byte_enables_out = {state[0], state[0], state[0], state[0]};

    assign data_valid_out = state[2];

    assign end_transaction_out = state[3];

    always @(posedge clock) begin
        if(reset == 1) begin
            burstCounter <= 9'b0;
            blockCounter <= 10'b0;
            busAddress <= 32'b0;
        end else if((state == READ && data_valid_in == 1) || (state == WRITE && busy_in == 0)) begin
            burstCounter <= burstCounter + 1;                                       
            blockCounter <= blockCounter + 1;                                       
            busAddress <= busAddress + 4;
        end else if (state == INIT) begin
            burstCounter <= 9'b0;
            blockCounter <= blockCounter;
            busAddress <= busAddress;
        end else if (state == IDLE) begin
            burstCounter <= 9'b0;
            blockCounter <= 10'b0;
            busAddress <= busStart;
        end else begin
            burstCounter <= burstCounter;
            blockCounter <= blockCounter;
            busAddress <= busAddress;
        end
    end

    always @(posedge clock) begin
        if(reset == 1) begin
            burstToShow <= 0;
        end else if((state == REQUEST && grantRequest == 1)) begin
            burstToShow <= (blockSize - blockCounter) < burstSize ? (blockSize - blockCounter - 10'd1) : (burstSize - 9'd1);
        end else begin
            burstToShow <= 0;
        end
    end

    // FSM 

    always @(posedge clock) begin
        if (reset == 1) begin
            state <= IDLE;
            statusRegister <= 2'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (controlRegister[0] != controlRegister[1] && blockSize != 0) begin
                        statusRegister <= 2'd1; 
                        state <= REQUEST;
                    end else begin
                        state <= IDLE;
                        statusRegister <= statusRegister;
                    end
                end
                REQUEST: begin
                    if(grantRequest == 1) begin 
                        state <= INIT;
                        statusRegister <= statusRegister;
                    end else begin
                        state <= REQUEST;
                        statusRegister <= statusRegister;
                    end
                end
                INIT: begin
                    if (controlRegister[0] == 1'b1) begin
                        state <= READ;
                        statusRegister <= statusRegister;
                    end else begin
                        state <= WRITE;
                        statusRegister <= statusRegister;
                    end
                end
                READ: begin
                    if(error_in == 1) begin 
                        statusRegister <= 2'd2;
                        state <= CLOSE;
                    end else if (end_transaction_in == 1) begin 
                        if (blockCounter == blockSize) begin
                            statusRegister <= 2'd0;
                            state <= IDLE;
                        end else begin
                            state <= REQUEST;
                            statusRegister <= statusRegister;
                        end
                    end else begin
                        state <= READ;
                        statusRegister <= statusRegister;
                    end
                end
                WRITE: begin
                    if(error_in == 1) begin 
                        statusRegister <= 2'd2;
                        state <= CLOSE;
                    end else if (blockCounter + 1 == blockSize && busy_in == 1'b0) begin
                        statusRegister <= 2'd0;
                        state <= CLOSE;
                    end else if (burstCounter + 1 == burstSize && busy_in == 1'b0) begin
                        state <= C2R;
                        statusRegister <= statusRegister;
                    end else begin
                        state <= WRITE;
                        statusRegister <= statusRegister;
                    end    
                end
                C2R: begin
                   state <= REQUEST; 
                   statusRegister <= statusRegister;
                end
                CLOSE: begin
                    state <= IDLE;
                    statusRegister <= statusRegister;
                end
                default: begin
                    statusRegister <= 2'd0; 
                    state <= IDLE;
                end
            endcase
        end
    end
    
endmodule