module dHash #(parameter [7:0] customId = 8'd0) (
    input wire         clock, camClock, reset, hsync, vsync, ciStart, validCamera,
    input wire [7:0]   ciN, camData,
    
    input wire [31:0]  ciValueA, ciValueB,
    output wire [31:0] ciResult,
    output wire        ciDone
);

// Potrebbe essere un problema di clock. tutti i segnali che gli arrivano dalla camera
// gli arrivano clockati su pclock. dHash però lavora con system clock. da tb non si vede
// Per ora ho fatto passare l'output in synchroFlop prima di passarlo a result.

    wire[127:0] signatureOut;

    reg[127:0] signatureReg, currentSignatureReg;
    reg[7:0] previousPixelReg;
    reg [5:0] pixelCounterReg, rowCounterReg;
    reg firstPixelReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign ciDone = validInstr;
    assign ciResult = (validInstr == 1'b0) ? 32'b0 : 
                            (ciValueA[1:0] == 2'b00) ? signatureOut[31:0] : 
                                (ciValueA[1:0] == 2'b01) ? signatureOut[63:32] : 
                                    (ciValueA[1:0] == 2'b10) ? signatureOut[95:64] : 
                                        (ciValueA[1:0] == 2'b11) ? signatureOut[127:96] : 32'b0; 

    always @(posedge camClock) begin
        pixelCounterReg     <= (reset == 1'b1 || hsync == 1'b1) ? 6'd62 : (validCamera == 1'b1) ? 
                                    (pixelCounterReg == 6'd44) ? 6'd0 : pixelCounterReg + 6'd1 : pixelCounterReg;

        // Rimettere 47! Messo 1 per TB
        rowCounterReg       <= (reset == 1'b1 || vsync == 1'b1) ? 6'd0 : (hsync == 1'b1) ? 
                                    (rowCounterReg == 6'd1) ? 6'd0 : rowCounterReg + 6'd1 : rowCounterReg;

        firstPixelReg       <= (reset == 1'b1 || hsync == 1'b1) ? 1'b0 : (validCamera == 1'b1) ? 1'b1 : firstPixelReg;

        currentSignatureReg <= (reset == 1'b1 || vsync == 1'b1) ? 128'b0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0 && firstPixelReg == 1'b1) ? 
                                        {currentSignatureReg[126:0], (camData > previousPixelReg) ? 1'b1 : 1'b0} : currentSignatureReg;

        previousPixelReg    <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : 
                                    (validCamera == 1'b1 && pixelCounterReg == 6'd0 && rowCounterReg == 6'd0) ? camData : previousPixelReg;

        signatureReg        <= (reset == 1'b1) ? 128'b0 : (vsync == 1'b1) ? currentSignatureReg : signatureReg;
    end
    
    genvar i;
    generate
        for (i = 127; i>=0; i = i-1) begin
                synchroFlop sns (.clockIn(camClock),
                    .clockOut(clock),
                    .reset(reset),
                    .D(signatureReg[i]),
                    .Q(signatureOut[i]));
        end
    endgenerate


endmodule