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
    parameter ERROR = 3'd4;
    

    reg[31:0] busStart;
    reg[8:0] memoryStart;
    reg[9:0] blockSize;
    reg[7:0] burstSize;
    reg[1:0] statusRegister;
    reg[1:0] controlRegister;

    reg[31:0] addressBus; //incrementare

    reg [8:0] memAddress; //incrementare

    assign readSettings = (validInstruction == 0 || writeEnable == 1) ? 32'b0 : 
                            (configurationBits == 3'b001) ? busStart : 
                                (configurationBits == 3'b010) ? memoryStart : 
                                    (configurationBits == 3'b011) ? blockSize :
                                        (configurationBits == 3'b100) ? burstSize :
                                            (configurationBits == 3'b101) ? statusRegister : 32'b0; 


    assign busRequest = (state == REQUEST) ? 1'b1 : 1'b0;

    assign begin_transaction = (state == INIT) ? 1'b1 : 1'b0;
    assign read_n_write = (state == INIT) ? (controlRegister[0] == 1) ? 1'b1 : 1'b0;
    assign address_data = (state == INIT) ? addressBus : 32'b0;
    assign burst_size = //to do

    assign memAddress = memAddress;
    assign memWriteEnable = (state == READ && data_valid == 1) ? 1'b1 : 1'b0;
    assign memDataOut = address_data;

    assign end_transaction = (state == ERROR) ? 1'b1 : 1'b0;

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
                3'b100: burstSize <= writeSettings[7:0];
                3'b101: controlRegister <= 1'b1; //set operation
                default: //not so sure
            endcase
        end else begin
            //not so sure
        end
    end

    always @(posedge clock) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (controlRegister[0] != controlRegister[1]) begin
                        statusRegister[0] <= 1'b1; 
                        controlRegister <= 2'b0;
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
                    state <= READ;
                end
                READ: begin
                    if(error == 1) begin 
                        statusRegister[1] <= 1'b1;
                        state <= ERROR;
                    end else if (end_transaction == 1) begin 
                        if (blockDone == 1) begin
                            state <= IDLE;
                        end else begin
                            state <= REQUEST;
                        end
                    end else begin
                        state <= READ;
                    end
                end
                ERROR: begin
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