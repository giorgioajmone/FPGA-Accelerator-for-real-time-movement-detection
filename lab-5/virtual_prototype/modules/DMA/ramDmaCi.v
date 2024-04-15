module ramDmaCi #(
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

    reg[1:0] counter; // modification

    wire is_valid, is_memory;
    wire[1:0] status;

    wire[31:0] dataOutA, resultMem, resultDMA;
    wire doneMem, doneDMA;

    wire[8:0] memAddress;
    wire[31:0] memDataIn, memDataOut;
    wire memWriteEnable;

    assign doneDMA = (is_valid == 1'b1 && ~is_memory) ? 1'b1 : 1'b0;
    assign doneMem = (is_valid == 1'b1 && is_memory && (counter == 2'd2 || valueA[9] == 1'b1) )? 1'b1 : 1'b0; //se scrittura subito up altrimenti dopo due clock

    assign resultMem = (is_valid == 1'b1 && is_memory) ? dataOutA : 32'b0;

    assign done = doneDMA | doneMem;
    assign result = resultMem | resultDMA;

    assign is_valid = (ciN == customId && start == 1'b1);
    assign is_memory = (valueA[12:10] == 3'b0);

    // modification: logic for counter
    always@(posedge clock) begin
        if(reset == 1'b1) begin
            counter = 0;
        end else begin
            counter <= (counter == 2'd2) ? 2'd0 : counter + 1;
        end

    end

    dualPortSSRAM #(.bitwidth(32), .nrOfEntries(512), .readAfterWrite(0)) memory(
        .clockA(clock),
        .clockB(~clock),
        .writeEnableA(is_valid && valueA[9] && is_memory),
        .writeEnableB(memWriteEnable),
        .addressA(valueA[8:0]),
        .addressB(memAddress),
        .dataInA(valueB),
        .dataInB(memDataOut),
        .dataOutA(dataOutA),
        .dataOutB(memDataIn)
    );

    DMAController dmaController(
        .validInstruction(is_valid),
        .writeEnable(valueA[9]),
        .clock(clock),
        .reset(reset),
        .configurationBits(valueA[12:10]),
        .readSettings(resultDMA),
        .writeSettings(valueB),
        .status(status),

        .memAddress(memAddress),
        .memDataIn(memDataIn),
        .memDataOut(memDataOut),
        .memWriteEnable(memWriteEnable),

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