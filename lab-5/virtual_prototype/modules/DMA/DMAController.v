module DMAController (
    input wire validInstruction, writeEnable, clock, reset
    input wire[2:0] configurationBits,
    output wire[31:0] readSettings,
    input wire[31:0] writeSettings,
    output wire[1:0] status,

    //bus ports
    inout wire[31:0] address_data,
    inout wire[3:0] byte_enables,
    inout wire[7:0] burst_size,
    inout wire read_n_write, begin_transaction, end_transaction, data_valid, busy, error
);

    reg[31:0] busStart;
    reg[8:0] memoryStart;
    reg[9:0] blockSize;
    reg[7:0] burstSize;
    reg[1:0] statusRegister;
    reg controlRegister;

    assign readSettings = (validInstruction == 0 || writeEnable == 1) ? 32'b0 : 
                            (configurationBits == 3'b001) ? busStart : 
                                (configurationBits == 3'b010) ? memoryStart : 
                                    (configurationBits == 3'b011) ? blockSize :
                                        (configurationBits == 3'b100) ? burstSize :
                                            (configurationBits == 3'b101) ? statusRegister : 32'b0; 



    assign status = statusRegister;

    always @(posedge clock)begin
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
                3'b101: controlRegister <= 1'b1;
                default: //not so sure
            endcase
        end else begin
            //not so sure
        end
    end

    
endmodule