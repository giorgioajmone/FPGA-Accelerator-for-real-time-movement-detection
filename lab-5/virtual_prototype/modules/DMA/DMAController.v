module DMAController (
    input wire validInstruction, writeEnable, clock, reset
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
    inout wire[31:0] address_data,
    inout wire[3:0] byte_enables,
    inout wire[7:0] burst_size,
    inout wire read_n_write, begin_transaction, end_transaction, data_valid, busy, error,
    input wire grantRequest,
    output wire busRequest
);

    parameter IDLE = 3'd0;
    parameter REQUEST = 3'd1;
    parameter INIT = 3'd2;
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

    //CPU

    assign readSettings = (validInstruction == 0) ? 32'b0 : 
                            (configurationBits == 3'b001) ? busStart : 
                                (configurationBits == 3'b010) ? memoryStart : 
                                    (configurationBits == 3'b011) ? blockSize :
                                        (configurationBits == 3'b100) ? burstSize :
                                            (configurationBits == 3'b101) ? statusRegister : 32'b0; 

    assign status = statusRegister;
    
    always @(posedge clock) begin
        if(reset == 1) begin
            busStart <= 0; 
            memory <= 0;
            blockSize <= 0;
            burstSize <= 0;
            statusRegister <= 0;
            controlRegister <= 0;
        end else if(validInstruction == 1 && writeEnable == 1) begin
            case configurationBits:
                3'b001: busStart <= writeSettings;
                3'b010: memoryStart <= writeSettings[8:0];
                3'b011: blockSize <= writeSettings[9:0];
                3'b100: burstSize <= writeSettings[7:0] + 1;
                3'b101: controlRegister <= writeSettings[1:0]; //set operation
                default: //not so sure
            endcase
        end
    end

    // MEMORY

    assign memAddress = memAddress_r;
    assign memWriteEnable = (state == READ && data_valid == 1) ? 1'b1 : 1'b0;
    assign memDataOut = address_data;

    always @(posedge clock) begin
        if(reset == 1) begin 
            memAddress_r <= 9'b0;
        end else if((state == READ || STATE == WRITE) && data_valid == 1) begin
            memAddress_r <= memAddress_r + 1;
        end else if (state == INIT) begin
            memAddress_r <= memoryStart;
        end else begin
            memAddress_r <= memAddress_r;
        end
    end

    // BUS

    assign busRequest = (state == REQUEST) ? 1'b1 : 1'b0;

    assign begin_transaction = (state == INIT) ? 1'b1 : 1'b0;
    assign read_n_write = (state == INIT) ? (controlRegister[0] == 1) ? 1'b1 : 1'b0 : 1'b0;
    assign address_data = (state == INIT) ? busAddress : (state == WRITE) ? memDataIn: 32'b0; 
    assign burst_size = () // parte brutta con modulo
    
    assign data_valid = (state == WRITE && memCounter[2] == 1'b1 && !busy) ? 1'b1 : 1'b0;

    assign end_transaction = (state == CLOSE || state == C2R) ? 1'b1 : 1'b0;

    always @(posedge clock) begin
        if (reset == 1) begin 
            memCounter <= 3'b0;
        end else if(state == WRITE && !busy) begin
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
            blockCounter <= 10'0;
            busAddress <= 32'b0;
        end else if((state == READ || STATE == WRITE) && data_valid == 1) begin
            burstCounter <= burstCounter + 1;
            blockCounter <= blockCounter + 1;
            busAddress <= busAddress + 4; //byte addressable
        end else if (state == INIT) begin
            burstCounter <= 9'b0;
            blockCounter <= 10'0;
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
                    if (controlRegister[0] != controlRegister[1]) begin
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
                    controlRegister <= 2'b0;
                    state <= READ;
                end
                READ: begin
                    if(error == 1) begin 
                        statusRegister[1] <= 1'b1;
                        state <= CLOSE;
                    end else if (end_transaction == 1) begin 
                        if (blockCounter == blockSize) begin
                            statusRegister[0] <= 1'b0;
                            state <= IDLE;
                        end else begin
                            state <= REQUEST;
                        end
                    end else begin
                        state <= READ;
                    end
                end
                WRITE: begin
                    if(error == 1) begin 
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
                    state <= IDLE;
                end
                default: begin
                    statusRegister[0] <= 1'b0; 
                    state <= IDLE;
                end
            endcase
        end
    end
    
endmodule