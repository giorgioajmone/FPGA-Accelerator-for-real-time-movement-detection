module dHash #(parameter [7:0] customId = 8'd0) (
    input wire         clock, reset, hsync, vsync, ciStart, validCamera,
    input wire [7:0]   ciN, camData,
    
    input wire [31:0]  ciValueA, ciValueB,
    output wire [31:0] ciResult,
    output wire        ciDone
);

    reg[127:0] signatureReg, currentSignatureReg;
    reg[7:0] previousPixelReg;
    reg [5:0] pixelCounterReg, rowCounterReg;
    reg firstPixelReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign ciDone = validInstr;
    assign ciResult = (validInstr == 1'b0) ? 32'b0 : 
                            (ciValueA[1:0] == 2'b00) ? signatureReg[31:0] : 
                                (ciValueA[1:0] == 2'b01) ? signatureReg[63:32] : 
                                    (ciValueA[1:0] == 2'b10) ? signatureReg[95:64] : 
                                        (ciValueA[1:0] == 2'b11) ? signatureReg[127:96] : 32'b0; 

    always @(posedge clock) begin
        pixelCounterReg     <= (reset == 1'b1 || hsync == 1'b1) ? 6'd62 : (validCamera == 1'b1) ? 
                                    (pixelCounterReg == 6'd44) ? 6'd0 : pixelCounterReg + 6'd1 : pixelCounterReg;

        rowCounterReg       <= (reset == 1'b1 || vsync == 1'b1) ? 6'd0 : (hsync == 1'b1) ? 
                                    (rowCounterReg == 6'd47) ? 6'd0 : rowCounterReg + 6'd1 : rowCounterReg;

        firstPixelReg       <= (reset == 1'b1 || hsync == 1'b1) ? 1'b0 : (validCamera == 1'b1) ? 1'b1 : firstPixelReg;

        currentSignatureReg <= (reset == 1'b1 || vsync == 1'b1) ? 128'b0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0 && firstPixelReg == 1'b1) ? 
                                        {currentSignatureReg[126:0], (camData > previousPixelReg) ? 1'b1 : 1'b0} : currentSignatureReg;

        previousPixelReg    <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0) ? camData : previousPixelReg;

        signatureReg        <= (reset == 1'b1) ? 128'b0 : (vsync == 1'b1) ? currentSignatureReg : signatureReg;
    end
    
endmodule