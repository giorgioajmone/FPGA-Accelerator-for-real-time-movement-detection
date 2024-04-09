module moduleName #(
    parameter[7:0] customId = 8'h00
) (
    input wire      start,
                    clock,
                    reset,
    input wire[31:0] valueA, valueB,
    input wire[7:0] ciN,
    output wire done, 
    output wire[31:0] result,

    //bus ports
    inout wire[31:0] address_data,
    inout wire[3:0] byte_enables,
    inout wire[7:0] burst_size,
    inout wire read_n_write, begin_transaction, end_transaction, data_valid, busy, error
);

    wire is_valid;
    wire[1:0] status;

    assign result = (is_valid == 1'b1) ? (gray) : 32'b0;
    assign is_valid = (iseId == customId && start == 1'b1);

    Memory #(.bitwidth(32), .nrOfEntries(512), .readAfterWrite(0)) memory(
        .clockA(clock),
        .clockB(clock),
        .writeEnableA(),
        .writeEnableB(),
        .addressA(),
        .addressB(),
        .dataInA(),
        .dataInB(),
        .dataOutA(),
        .dataOutB()
    )

    DMAController dmaController(
        .validInstruction(is_valid),
        .writeEnable(valueA[9]),
        .clock(clock),
        .reset(reset),
        .configurationBits(valueA[12:10]),
        .readSettings(result),
        .writeSettings(valueB),
        .status(status),
        .address_data(address_data),
        .byte_enables(byte_enables),
        .burst_size(burst_size),
        .read_n_write(read_n_write),
        .begin_transaction(begin_transaction),
        .end_transaction(end_transaction),
        .data_valid(data_valid),
        .busy(busy),
        .error(error)
    );
    
endmodule