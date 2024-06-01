module dHash #(parameter [7:0] customId = 8'd0) (
    input wire         clock, camClock, reset, hsync, vsync, ciStart, validCamera, takeSignature,
    input wire [7:0]   ciN, camData,
    
    input wire [31:0]  ciValueA, ciValueB,
    output wire [31:0] ciResult,
    output wire        ciDone
);

    reg[31:0] currentSignatureReg;
    reg[7:0] previousPixelReg;
    reg[5:0] pixelCounterReg, rowCounterReg;
    reg firstPixelReg, doneReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign ciResult = (ciN == customId) ? readData : 32'b0;
    assign ciDone = doneReg;

    
    always @(posedge clock) begin
        doneReg <= (reset == 1'b1) ? 1'b0 : validInstr;
    end

    always @(posedge camClock) begin
        pixelCounterReg     <= (reset == 1'b1 || hsync == 1'b1) ? 6'd62 : (validCamera == 1'b1) ? 
                                    (pixelCounterReg == 6'd44) ? 6'd0 : pixelCounterReg + 6'd1 : pixelCounterReg;

        rowCounterReg       <= (reset == 1'b1 || vsync == 1'b1) ? 6'd0 : (hsync == 1'b1) ? 
                                    (rowCounterReg == 6'd47) ? 6'd0 : rowCounterReg + 6'd1 : rowCounterReg;

        firstPixelReg       <= (reset == 1'b1 || hsync == 1'b1) ? 1'b0 : (validCamera == 1'b1) ? 1'b1 : firstPixelReg;

        currentSignatureReg <= (reset == 1'b1 || vsync == 1'b1) ? 128'b0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0 && firstPixelReg == 1'b1) ? 
                                        {currentSignatureReg[30:0], (camData > previousPixelReg) ? 1'b1 : 1'b0} : currentSignatureReg;
                            
        previousPixelReg    <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0) ? camData : previousPixelReg;

    end

    wire[31:0] readData;
    reg[6:0] comparisonCounterReg;
    wire bufferEnable;

    always @(posedge camClock ) begin
        comparisonCounterReg <= (reset == 1'b1 || vsync == 1'b1) ? 7'b1111111 : (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0 && firstPixelReg == 1'b1) ? comparisonCounterReg + 1 : comparisonCounterReg;
    end

    assign bufferEnable = (comparisonCounterReg[4:0] == 5'b11111 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0 && validCamera == 1'b1) ? 1'b1 : 1'b0;

    dualPortRam #(.nrOfEntries(4), .entryLength(32)) signatureBuffer (.address1(comparisonCounterReg[6:5]),
                                        .address2(ciValueA[1:0]),
                                        .clock1(camClock),
                                        .clock2(clock),
                                        .writeEnable(bufferEnable & takeSignature),
                                        .dataIn1(currentSignatureReg),
                                        .dataOut2(readData));
endmodule