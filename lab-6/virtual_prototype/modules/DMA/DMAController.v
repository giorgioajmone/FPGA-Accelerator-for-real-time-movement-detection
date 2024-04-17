module DMAController (
    input wire validInstruction, writeEnable, clock, reset,
    input wire[2:0] configurationBits,
    output wire[31:0] readSettings,
    input wire[31:0] writeSettings,
    output wire[1:0] status,

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

    reg[2:0] state;     // modification
    localparam IDLE = 3'd0;
    parameter REQUEST = 3'd1;
    localparam INIT = 3'd2;
    parameter READ = 3'd3;
    parameter CLOSE = 3'd4;
    parameter WRITE = 3'd5;
    parameter C2R = 3'd6;
    
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
    

    reg[0:2] memCounter = 3'b0;

    wire data_valid_sc;

    //CPU

    assign readSettings = (validInstruction == 0 || writeEnable == 1) ? 32'b0 : 
                            (configurationBits == 3'b001) ? busStart : 
                                (configurationBits == 3'b010) ? memoryStart : 
                                    (configurationBits == 3'b011) ? blockSize :
                                        (configurationBits == 3'b100) ? burstSize :
                                            (configurationBits == 3'b101) ? statusRegister : 32'b0; 

    assign status = statusRegister;
    
    always @(posedge clock) begin
        if(reset == 1) begin
            busStart <= 0; 
            memoryStart <= 0; 
            blockSize <= 0;
            burstSize <= 0;
            statusRegister <= 0;
            controlRegister <= 0;
        end else if(validInstruction == 1 && writeEnable == 1) begin
            case (configurationBits)
                3'd1: begin  busStart <= writeSettings; end
                3'd2: begin  memoryStart <= writeSettings[8:0]; end
                3'd3: begin  blockSize <= writeSettings[9:0]; end
                3'd4: begin burstSize <= writeSettings[7:0] + 1; end
                3'd5: begin controlRegister <= writeSettings[1:0]; end
                default: begin end//not so sure
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
        end else if((state == READ && data_valid_in == 1) || (state == WRITE && data_valid_sc == 1)) begin
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

    assign busRequest = (state == REQUEST) ? 1'b1 : 1'b0;

    assign begin_transaction_out = (state == INIT) ? 1'b1 : 1'b0;
    assign read_n_write_out = (state == INIT) ? (controlRegister[0] == 1) ? 1'b1 : 1'b0 : 1'b0;
    assign address_data_out = (state == INIT) ? busAddress : (state == WRITE) ? memDataIn: 32'b0; 
    assign burst_size_out = (state == INIT) ? (blockSize - blockCounter) < burstSize ? (blockSize - blockCounter) : burstSize[7:0] : 8'b0;
    assign byte_enables_out = (state == INIT && controlRegister == 2'd2) ? 4'b1 : 4'b0;
    assign data_valid_sc = (state == WRITE && memCounter == 2'd2 && !busy_in) ? 1'b1 : 1'b0;

    assign data_valid_out = data_valid_sc;

    assign end_transaction_out = (state == CLOSE || state == C2R) ? 1'b1 : 1'b0;

    always @(posedge clock) begin
        if (reset == 1) begin 
            memCounter <= 3'b0;
        end else if(state == WRITE && !busy_in) begin
            memCounter <= (memCounter == 2'd2) ? 0 : memCounter + 1;
        end else if(state == INIT) begin
            memCounter <= 0;
        end else begin
            memCounter <= memCounter;
        end
    end

    always @(posedge clock) begin
        if(reset == 1) begin
            burstCounter <= 9'b0;
            blockCounter <= 10'b0;
            busAddress <= 32'b0;
        end else if((state == READ && data_valid_in == 1) || (state == WRITE && data_valid_sc == 1)) begin  // maybe only put data valid to not lose a clk cycle
            burstCounter <= burstCounter + 1;                                       
            blockCounter <= blockCounter + 1;                                       
            busAddress <= busAddress + 4; //byte addressable
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

    // FSM ( TO DO: migliorare gestione status e control register)

    always @(posedge clock) begin
        if (reset == 1) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (controlRegister[0] != controlRegister[1] && blockSize != 0) begin
                        statusRegister <= 2'd1; 
                        state <= REQUEST;
                    end else begin
                        statusRegister[0] <= 1'b0; 
                        state <= IDLE;
                    end
                end
                REQUEST: begin
                    if(grantRequest == 1) begin 
                        state <= INIT;
                    end else begin
                        state <= REQUEST;
                    end
                end
                INIT: begin
                    if (controlRegister == 2'd1) begin
                        state <= READ;
                    end else begin
                        state <= WRITE;
                    end
                end
                READ: begin
                    if(error_in == 1) begin 
                        statusRegister[1] <= 1'b1;
                        state <= CLOSE;
                    end else if (end_transaction_in == 1) begin 
                        if (blockCounter == blockSize) begin
                            statusRegister[0] <= 1'b0;
                            controlRegister <= 2'b0;
                            state <= IDLE;
                        end else begin
                            state <= REQUEST;
                        end
                    end else begin
                        state <= READ;
                    end
                end
                WRITE: begin
                    if(error_in == 1) begin 
                        statusRegister[1] <= 1'b1;
                        state <= CLOSE;
                    end else if (blockCounter == blockSize) begin
                        statusRegister[0] <= 1'b0;
                        state <= CLOSE;
                    end else if (burstCounter == burstSize) begin
                        state <= C2R;
                    end else begin
                        state <= WRITE;
                    end    
                end
                C2R: begin
                   state <= REQUEST; 
                end
                CLOSE: begin
                    statusRegister[0] <= 1'b0;
                    controlRegister <= 2'b0;
                    state <= IDLE;
                end
                default: begin
                    statusRegister[0] <= 1'b0; 
                    controlRegister <= 2'b0;
                    state <= IDLE;
                end
            endcase
        end
    end
    
endmodule