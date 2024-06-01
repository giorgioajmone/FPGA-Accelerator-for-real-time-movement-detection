module sobelAccelerator #(parameter [7:0] customId = 8'd0) (
    input wire         clock, camClock, reset, hsync, vsync, ciStart, validCamera,
    input wire [7:0]   ciN, camData,
    
    input wire [31:0]  ciValueA, ciValueB,
    output wire [31:0] ciResult,
    output wire        ciDone,

    output wire        requestBus,
    input wire         busGrant,
    output reg         beginTransactionOut,
    output wire [31:0] addressDataOut,
    output reg         endTransactionOut,
    output reg  [3:0]  byteEnablesOut,
    output wire        dataValidOut,
    output reg  [7:0]  burstSizeOut,
    input wire         busyIn, busErrorIn, 
    output wire        takeSignature
);

    genvar i, j;

    reg[31:0] busStartReg;
    reg[15:0] thresholdReg;

    reg transferModeReg;
    reg[1:0] statusReg;
    reg transferDoneReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign takeSignature = statusReg[0];
    
    assign ciDone = validInstr;
    assign ciResult = (validInstr == 1'b0 || ciValueA[9] == 1'b1) ? 32'b0 : 
                            (ciValueA[12:10] == 3'b001) ? busStartReg : 
                              (ciValueA[12:10] == 3'b100) ? thresholdReg :
                                  (ciValueA[12:10] == 3'b101) ? transferDoneReg: 32'b0; 

    always @ (posedge clock) begin
      busStartReg <= (reset == 1'b1) ? 32'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0011) ? 
                        ciValueB : busStartReg;

      thresholdReg <= (reset == 1'b1) ? 16'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1001) ? 
                        ciValueB[15:0] : thresholdReg;

      transferModeReg <= (reset == 1'b1 || statusReg[0] == 1'b1) ? 1'b0 : 
                            (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011) ? 1'b1 : transferModeReg;

      statusReg <= (reset == 1'b1 || statusReg[1] == 1'b1) ? 2'b0 : (newScreen == 1'b1) ? 
                      {statusReg[0], transferModeReg} : statusReg;

      transferDoneReg <= (reset == 1'b1 || (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011)) ? 1'b0 : 
                            (statusReg[1] == 1'b1) ? 1'b1 : transferDoneReg;
    end

  // ================================================== Sobel Conversion ==================================================

    reg[7:0] addressReg [0:8];
    wire[7:0] address [0:8];

    wire[15:0] writeDataX [0:8];
    wire[15:0] readDataX [0:8];
    
    wire[15:0] writeDataY [0:8];
    wire[15:0] readDataY [0:8];

    wire[7:0] nextAddress [0:8];

   
    generate
        for(i = 0; i < 9; i = i + 1) begin : wire_address
          assign address[i] = addressReg[i];
        end
    endgenerate

    generate
        for(i = 0; i < 9; i = i + 1) begin : buffer_instantiation
          sobelBuffer  bufferX(.addressIn(address[i]), .addressOut(address[i]), 
                                  .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                      .dataIn(writeDataX[i]), .dataOut(readDataX[i]));

          sobelBuffer  bufferY(.addressIn(address[i]), .addressOut(address[i]), 
                                  .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                      .dataIn(writeDataY[i]), .dataOut(readDataY[i]));                            
        end
    endgenerate


    // ================================================== Address Management ==================================================

    generate
      for(i = 0; i < 3; i = i + 1) begin : generateAddr1
        for(j = 0; j < 3; j = j + 1) begin : generateAddr2
          assign nextAddress[i * 3 + j] = addressReg[j] + pixelCount[(j+2)%3];
        end
      end          
    endgenerate

    always @(posedge camClock) begin
        addressReg[0] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : 
                            (validCamera == 1'b1) ? nextAddress[0] : addressReg[0];

        addressReg[1] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[1] : addressReg[1];

        addressReg[2] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[2] : addressReg[2];

        addressReg[3] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : 
                            (validCamera == 1'b1) ? nextAddress[3] : addressReg[3];

        addressReg[4] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[4] : addressReg[4];

        addressReg[5] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[5] : addressReg[5];

        addressReg[6] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : 
                            (validCamera == 1'b1) ? nextAddress[6] : addressReg[6];

        addressReg[7] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[7] : addressReg[7];

        addressReg[8] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : 
                            (validCamera == 1'b1) ? nextAddress[8] : addressReg[8];
    end    

    // ================================================== Value Management ==================================================  

    wire[15:0] filteredDataX[0:8], filteredDataY[0:8];

    wire[15:0] partialA  = camData;
    wire[15:0] partialB  = camData << 1;
    wire[15:0] partialC = ~camData + 1;
    wire[15:0] partialD = ~(camData << 1) + 1; 

    generate
      for(i = 0; i < 3; i = i + 1) begin : generateValue1
        for(j = 0; j < 3; j = j + 1) begin : generateValue2
          assign writeDataX[i * 3 + j] = (rowCount[i] & pixelCount[j]) ? (filteredDataX[i * 3 + j]) : 
                                            (readDataX[i * 3 + j] + filteredDataX[i * 3 + j]);
          
          assign writeDataY[i * 3 + j] = (rowCount[i] & pixelCount[j]) ? (filteredDataY[i * 3 + j]) : 
                                            (readDataY[i * 3 + j] + filteredDataY[i * 3 + j]);
          
          assign filteredDataX[i * 3 + j] = (pixelCount[j] & (rowCount[i] | rowCount[(i+2)%3])) ? partialC : 
                                              (pixelCount[(j+2)%3] & (rowCount[i] | rowCount[(i+2)%3])) ? partialA : 
                                                (rowCount[(i+1)%3] & pixelCount[j]) ? partialD :
                                                  (rowCount[(i+1)%3] & pixelCount[(j+2)%3]) ? partialB : 16'b0;
                                          
          assign filteredDataY[i * 3 + j] =  (rowCount[i] & (pixelCount[j] | pixelCount[(j+2)%3])) ? partialA :
                                              (rowCount[(i+2)%3] & (pixelCount[j] | pixelCount[(j+2)%3])) ? partialC : 
                                                (rowCount[(i+2)%3] & pixelCount[(j+1)%3]) ? partialD : 
                                                  (rowCount[i] & pixelCount[(j+1)%3]) ? partialB : 16'b0;
        end
      end          
    endgenerate

    reg[15:0] outputY, outputX;

    always @(negedge camClock) begin
      outputY <=    writeDataY[0] & {16{rowCount[2] & pixelCount[2]}} |
                      writeDataY[1] & {16{rowCount[2] & pixelCount[0]}} |
                      writeDataY[2] & {16{rowCount[2] & pixelCount[1]}} |
                      writeDataY[3] & {16{rowCount[0] & pixelCount[2]}} |
                      writeDataY[4] & {16{rowCount[0] & pixelCount[0]}} |
                      writeDataY[5] & {16{rowCount[0] & pixelCount[1]}} |
                      writeDataY[6] & {16{rowCount[1] & pixelCount[2]}} |
                      writeDataY[7] & {16{rowCount[1] & pixelCount[0]}} |
                      writeDataY[8] & {16{rowCount[1] & pixelCount[1]}}; 
          
      outputX <=    writeDataX[0] & {16{rowCount[2] & pixelCount[2]}} |
                      writeDataX[1] & {16{rowCount[2] & pixelCount[0]}} |
                      writeDataX[2] & {16{rowCount[2] & pixelCount[1]}} |
                      writeDataX[3] & {16{rowCount[0] & pixelCount[2]}} |
                      writeDataX[4] & {16{rowCount[0] & pixelCount[0]}} |
                      writeDataX[5] & {16{rowCount[0] & pixelCount[1]}} |
                      writeDataX[6] & {16{rowCount[1] & pixelCount[2]}} |
                      writeDataX[7] & {16{rowCount[1] & pixelCount[0]}} |
                      writeDataX[8] & {16{rowCount[1] & pixelCount[1]}};
    end
                            
    wire[15:0] absX = ({16{outputX[15]}} ^ outputX) + outputX[15];
    wire[15:0] absY = ({16{outputY[15]}} ^ outputY) + outputY[15];

    wire finalOutput = ((absX + absY) > thresholdReg) ? 1'b1 : 1'b0; 

    //  ================================================== FSM ==================================================            
    
    localparam S0  = 3'b001;
    localparam S1  = 3'b010;
    localparam S2  = 3'b100;

    reg[2:0] pixelCount, nextStateP;
    reg[2:0] rowCount, nextStateR;

    always @* begin
        case(pixelCount)
            S0:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : 
                                        (validCamera == 1'b1)  ? S1 : S0;

            S1:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : 
                                        (validCamera == 1'b1)  ? S2 : S1;

            S2:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : 
                                        (validCamera == 1'b1)  ? S0 : S2;

            default:    nextStateP <= S0;
        endcase
    end

    always @* begin
        case(rowCount)
            S0:         nextStateR <= (vsync == 1'b1) ? S0 : (hsync == 1'b1) ? S1 : S0;
            S1:         nextStateR <= (vsync == 1'b1) ? S0 : (hsync == 1'b1) ? S2 : S1;
            S2:         nextStateR <= (vsync == 1'b1) ? S0 : (hsync == 1'b1) ? S0 : S2;
            default:    nextStateR <= S0;
        endcase
    end

    always @(posedge camClock) begin
        pixelCount <= (reset == 1'b1) ? S0 : nextStateP; 
        rowCount <= (reset == 1'b1) ? S0 : nextStateR;
    end

    // ================================================== Buffer Management ==================================================

    reg[31:0] s2pReg;
    reg[9:0] writeBufferReg;

    wire bufferEnable = (writeBufferReg[4:0] == 5'b11111) ? validCamera: 1'b0;

    always @(posedge camClock) begin
        s2pReg <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 32'b0 : 
                    (validCamera == 1'b1) ? {s2pReg[30:0], finalOutput} : s2pReg;
    end
    
    always @(posedge camClock) begin
        writeBufferReg <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 10'b0 : 
                            (validCamera == 1'b1) ? writeBufferReg + 10'd1 : writeBufferReg;
    end

    dualPortRam #(.nrOfEntries(32), .entryLength(32)) lineBuffer (
      .address1(writeBufferReg[9:5]),
      .address2(memoryAddressReg),
      .clock1(camClock),
      .clock2(clock),
      .writeEnable(bufferEnable),
      .dataIn1(s2pReg),
      .dataOut2(busOutput)
    );

    // ================================================== Bus Management ==================================================
 
    localparam IDLE     = 3'd0;
    localparam REQUEST  = 3'd1;
    localparam INIT     = 3'd2;
    localparam CLOSE    = 3'd3;
    localparam WRITE    = 3'd4;
    localparam ERROR    = 3'd5;

    reg[2:0] stateReg, nextState; 
    wire newScreen, newLine;
    wire[31:0] busOutput;
    reg [31:0] busAddressReg, addressDataOutReg;
    reg [4:0] memoryAddressReg;
    reg dataValidReg;
    reg [5:0] burstCountReg;

    wire isWriting = ((stateReg == WRITE) && burstCountReg[5] == 1'b0) ? ~busyIn : 1'b0;

    wire [31:0] busAddressNext = (reset == 1'b1 || newScreen == 1'b1) ? busStartReg : 
                                    (isWriting == 1'b1) ? busAddressReg + 32'd4 : busAddressReg;
    
    assign requestBus        = (stateReg == REQUEST) ? 1'b1 : 1'b0;
    assign addressDataOut    = addressDataOutReg;
    assign dataValidOut      = dataValidReg;
    
    always @* begin
        case (stateReg)
            IDLE        : nextState <= ((statusReg[0] == 1'b1) && newLine == 1'b1) ? REQUEST : IDLE; 
            REQUEST     : nextState <= (busGrant == 1'b1) ? INIT : REQUEST;
            INIT        : nextState <= WRITE;

            WRITE       : nextState <= (busErrorIn == 1'b1) ? ERROR :
                                            (burstCountReg[5] == 1'b1 && busyIn == 1'b0) ? CLOSE : WRITE;

            CLOSE       : nextState <= IDLE;
            ERROR       : nextState <= IDLE;
            default     : nextState <= IDLE;
        endcase
    end
    
    always @(posedge clock) begin
        stateReg                <= (reset == 1'b1) ? IDLE : nextState;
        beginTransactionOut     <= (stateReg == INIT) ? 1'd1 : 1'd0;
        byteEnablesOut          <= (stateReg == INIT) ? 4'hF : 4'd0;

        addressDataOutReg       <= (stateReg == INIT) ? busAddressReg : 
                                        (isWriting == 1'b1) ? {busOutput[7:0], busOutput[15:8], busOutput[23:16], busOutput[31:24]} : 
                                            (busyIn == 1'b1) ? addressDataOutReg : 32'd0;

        dataValidReg            <= (isWriting == 1'b1) ? 1'b1 : 
                                        (busyIn == 1'b1) ? dataValidReg : 1'b0;

        endTransactionOut       <= (stateReg == CLOSE || stateReg == ERROR) ? 1'b1 : 1'b0;
        burstSizeOut            <= (stateReg == INIT) ? 8'd19 : 8'd0;

        burstCountReg           <= (stateReg == INIT) ? 6'd19 : 
                                        (isWriting == 1'b1) ? burstCountReg - 6'd1 : burstCountReg;

        memoryAddressReg        <= (stateReg == IDLE) ? 5'd0 : 
                                        (isWriting == 1'b1) ? memoryAddressReg + 5'd1 : memoryAddressReg;

        busAddressReg           <= busAddressNext;
    end

    synchroFlop sns (.clockIn(camClock),
                    .clockOut(clock),
                    .reset(reset),
                    .D(vsync),
                    .Q(newScreen));
  
    synchroFlop snl (.clockIn(camClock),
                    .clockOut(clock),
                    .reset(reset),
                    .D(hsync),
                    .Q(newLine));

endmodule