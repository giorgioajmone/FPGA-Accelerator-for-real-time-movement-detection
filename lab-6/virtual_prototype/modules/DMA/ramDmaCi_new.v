module ramDmaCi_new #( parameter [7:0] customId = 8'h00)
                 ( input wire start, clock, reset,
                   input wire [31:0] valueA, valueB,
                   input wire [7:0] ciN,
                   output wire done,
                   output wire [31:0] result,


                   input wire dmaAckBusIn,
                   input wire dmaBusErrorIn,
                   input wire dmaBusyIn,
                   input wire dmaEndTransactionIn,
                   input wire dmaDataValidIn,
                   input wire [31:0] dmaAddressDataIn,

                   output wire dmaRequestBusOut,
                   output wire dmaBeginTransactionOut,
                   output wire dmaEndTransactionOut,
                   output wire dmaReadNotWriteOut,
                   output wire dmaDataValidOut,
                   output wire [7:0] dmaBurstSizeOut,
                   output wire [3:0] dmaByteEnablesOut,
                   output wire [31:0] dmaAddressDataOut);


    // Define the CI signals
    wire s_isMyCi = (ciN == customId) ? start : 1'b0;
    wire writeAction = valueA[9] && s_isMyCi;
    wire writeEnableA = (valueA[12:10] == 3'b000) && writeAction;

    reg done_reg; // delayed by 1 cycle with respect to s_isMyCi
    assign done = (writeAction == 1'b1) ? s_isMyCi : done_reg; // read action takes 2 cycles

    always @(posedge clock or posedge reset)
    begin
        if (reset)
            done_reg <= 1'b0;
        else
            done_reg <= s_isMyCi;
    end

    wire [31:0] ssram_outA;
    wire [31:0] dmaControllerOut;
    assign result = (done == 1'b0) ? 32'h0000_0000 : ((valueA[12:10] == 3'b0) ? ssram_outA : dmaControllerOut);


    // Define the signals to interact with the DMA controller
    wire sigBusStartAddress = (valueA[12:10] == 3'b001) && s_isMyCi;
    wire readBusStartAddress = sigBusStartAddress && ~valueA[9];
    wire writeBusStartAddress = sigBusStartAddress && valueA[9];

    wire sigMemoryStartAddress = (valueA[12:10] == 3'b010) && s_isMyCi;
    wire readMemoryStartAddress = sigMemoryStartAddress && ~valueA[9];
    wire writeMemoryStartAddress = sigMemoryStartAddress && valueA[9];

    wire sigBlockSize = (valueA[12:10] == 3'b011) && s_isMyCi;
    wire readBlockSize= sigBlockSize && ~valueA[9];
    wire writeBlockSize= sigBlockSize && valueA[9];

    wire sigBurstSize= (valueA[12:10] == 3'b100) && s_isMyCi;
    wire readBurstSize= sigBurstSize && ~valueA[9];
    wire writeBurstSize= sigBurstSize && valueA[9];

    wire sigOther= (valueA[12:10] == 3'b101) && s_isMyCi;
    wire readStatusRegister= sigOther && ~valueA[9];
    wire writeControlRegister = sigOther && valueA[9];

    // Define the signals between SSRAM and DMA controller
    wire writeEnableB;
    wire [8:0] addressB;
    wire [31:0] ssram_outB;

    // Register the bus inputs
    reg [31:0] dmaAddressDataIn_reg;
    reg dmaEndTransactionIn_reg;
    reg dmaDataValidIn_reg;

    always @(posedge clock or posedge reset)
    begin
        if (reset) begin
            dmaAddressDataIn_reg <= 32'h0;
            dmaEndTransactionIn_reg <= 1'h0;
            dmaDataValidIn_reg <= 1'h0;
        end else begin
            dmaAddressDataIn_reg <= dmaAddressDataIn;
            dmaEndTransactionIn_reg <= dmaEndTransactionIn;
            dmaDataValidIn_reg <= dmaDataValidIn;
        end
    end

    // Instantiate the SSRAM
    dualPortSSRAM #(.bitwidth(32), .nrOfEntries(512)) ssram (
        .clockA(clock),
        .clockB(clock),
        .writeEnableA(writeEnableA),
        .writeEnableB(writeEnableB),
        .addressA(valueA[8:0]),
        .addressB(addressB),
        .dataInA(valueB),
        .dataInB(dmaAddressDataIn_reg),
        .dataOutA(ssram_outA),
        .dataOutB(ssram_outB)
    );

    // Instantiate the DMA controller with flip-flop registered bus inputs
    dma_new DMA (
        .clock(clock),
        .reset(reset),
        .readBusStartAddress(readBusStartAddress),
        .writeBusStartAddress(writeBusStartAddress),
        .readMemoryStartAddress(readMemoryStartAddress),
        .writeMemoryStartAddress(writeMemoryStartAddress),
        .readBlockSize(readBlockSize),
        .writeBlockSize(writeBlockSize),
        .readBurstSize(readBurstSize),
        .writeBurstSize(writeBurstSize),
        .readStatusRegister(readStatusRegister),
        .writeControlRegister(writeControlRegister),
        .dmaAckBusIn(dmaAckBusIn),
        .dmaAddressDataIn(dmaAddressDataIn_reg),
        .dmaBusErrorIn(dmaBusErrorIn),
        .dmaBusyIn(dmaBusyIn),
        .dmaDataValidIn(dmaDataValidIn_reg),
        .dmaEndTransactionIn(dmaEndTransactionIn_reg),
        .ci_valueBIn(valueB),
        .ssram_outBIn(ssram_outB),
        .writeEnableBOut(writeEnableB),
        .ci_resultOut(dmaControllerOut),
        .ssram_addressBOut(addressB),
        .dmaRequestBusOut(dmaRequestBusOut),
        .dmaBeginTransactionOut(dmaBeginTransactionOut),
        .dmaReadNotWriteOut(dmaReadNotWriteOut),
        .dmaByteEnablesOut(dmaByteEnablesOut),
        .dmaBurstSizeOut(dmaBurstSizeOut),
        .dmaDataValidOut(dmaDataValidOut),
        .dmaEndTransactionOut(dmaEndTransactionOut),
        .dmaAddressDataOut(dmaAddressDataOut)
    );
endmodule
