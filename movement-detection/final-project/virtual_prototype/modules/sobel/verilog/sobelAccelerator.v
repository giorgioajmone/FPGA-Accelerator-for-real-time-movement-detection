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

    reg[31:0] busStartReg;
    reg[9:0] blockSizeReg;
    reg[8:0] burstSizeReg;
    reg[15:0] thresholdReg;

    reg transferModeReg;
    reg[1:0] statusReg;
    reg transferDoneReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign takeSignature = statusReg[0];
    
    assign ciDone = validInstr;
    assign ciResult = (validInstr == 1'b0 || ciValueA[9] == 1'b1) ? 32'b0 : 
                            (ciValueA[12:10] == 3'b001) ? busStartReg : 
                                (ciValueA[12:10] == 3'b010) ? blockSizeReg : 
                                    (ciValueA[12:10] == 3'b011) ? burstSizeReg :
                                        (ciValueA[12:10] == 3'b100) ? thresholdReg :
                                            (ciValueA[12:10] == 3'b101) ? transferDoneReg: 32'b0; 

    always @ (posedge clock) begin
        busStartReg <= (reset == 1'b1) ? 32'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0011) ? ciValueB : busStartReg;
        blockSizeReg <= (reset == 1'b1) ? 10'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0101) ? ciValueB[9:0] : blockSizeReg;
        burstSizeReg <= (reset == 1'b1) ? 9'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0111) ? ciValueB[7:0] : burstSizeReg;
        thresholdReg <= (reset == 1'b1) ? 16'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1001) ? ciValueB[15:0] : thresholdReg;
        transferModeReg <= (reset == 1'b1 || statusReg[0] == 1'b1) ? 1'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011) ? 1'b1 : transferModeReg;
        statusReg <= (reset == 1'b1 || statusReg[1] == 1'b1) ? 2'b0 : (newScreen == 1'b1) ? {statusReg[0], transferModeReg} : statusReg;
        transferDoneReg <= (reset == 1'b1 || (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011)) ? 1'b0 : (statusReg[1] == 1'b1) ? 1'b1 : transferDoneReg;
    end

    reg[7:0] addressReg [0:8];
    wire [7:0] address [0:8];
    wire [15:0] writeDataX [0:8];
    wire [15:0] readDataX [0:8];
    
    wire [15:0] writeDataY [0:8];
    wire [15:0] readDataY [0:8];

    genvar j;
    generate
        for(j = 0; j < 9; j = j + 1) begin : wire_address
            assign address[j] = addressReg[j];
        end
    endgenerate


    genvar i;
    generate
        for(i = 0; i < 9; i = i + 1) begin : bufferX_instantiation
            sobelBuffer  bufferX(.addressIn(address[i]), .addressOut(address[i]), 
                                    .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                        .dataIn(writeDataX[i]), .dataOut(readDataX[i]));
        end
    endgenerate

    genvar k;
    generate
        for(k = 0; k < 9; k = k + 1) begin : bufferY_instantiation
            sobelBuffer  bufferY(.addressIn(address[k]), .addressOut(address[k]), 
                                    .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                        .dataIn(writeDataY[k]), .dataOut(readDataY[k]));
        end
    endgenerate  

    wire[7:0] nextAddress [0:8];

    assign nextAddress[0] = addressReg[0] + (pixelCount[2]);
    assign nextAddress[1] = addressReg[1] + (pixelCount[0]);
    assign nextAddress[2] = addressReg[2] + (pixelCount[1]);
    assign nextAddress[3] = addressReg[3] + (pixelCount[2]);
    assign nextAddress[4] = addressReg[4] + (pixelCount[0]);
    assign nextAddress[5] = addressReg[5] + (pixelCount[1]);
    assign nextAddress[6] = addressReg[6] + (pixelCount[2]);
    assign nextAddress[7] = addressReg[7] + (pixelCount[0]);
    assign nextAddress[8] = addressReg[8] + (pixelCount[1]);

    always @(posedge camClock) begin
        addressReg[0] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? nextAddress[0] : addressReg[0];
        addressReg[1] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[1] : addressReg[1];
        addressReg[2] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[2] : addressReg[2];
        addressReg[3] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? nextAddress[3] : addressReg[3];
        addressReg[4] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[4] : addressReg[4];
        addressReg[5] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[5] : addressReg[5];
        addressReg[6] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? nextAddress[6] : addressReg[6];
        addressReg[7] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[7] : addressReg[7];
        addressReg[8] <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 8'd255 : (validCamera == 1'b1) ? nextAddress[8] : addressReg[8];
    end      

    wire[15:0] filteredDataX[0:8];

    /* assign writeDataX[0] = (rowCount[0] & pixelCount[0]) ? (filteredDataX[0]) : (readDataX[0] + filteredDataX[0]);
    assign writeDataX[1] = readDataX[1] & (~{16{rowCount[0] & pixelCount[1]}}) + filteredDataX[1];
    assign writeDataX[2] = readDataX[2] & (~{16{rowCount[0] & pixelCount[2]}}) + filteredDataX[2];
    assign writeDataX[3] = readDataX[3] & (~{16{rowCount[1] & pixelCount[0]}}) + filteredDataX[3];
    assign writeDataX[4] = readDataX[4] & (~{16{rowCount[1] & pixelCount[1]}}) + filteredDataX[4];
    assign writeDataX[5] = readDataX[5] & (~{16{rowCount[1] & pixelCount[2]}}) + filteredDataX[5];
    assign writeDataX[6] = readDataX[6] & (~{16{rowCount[2] & pixelCount[0]}}) + filteredDataX[6];
    assign writeDataX[7] = readDataX[7] & (~{16{rowCount[2] & pixelCount[1]}}) + filteredDataX[7];
    assign writeDataX[8] = readDataX[8] & (~{16{rowCount[2] & pixelCount[2]}}) + filteredDataX[8]; */

    assign writeDataX[0] = (rowCount[0] & pixelCount[0]) ? (filteredDataX[0]) : (readDataX[0] + filteredDataX[0]);
    assign writeDataX[1] = (rowCount[0] & pixelCount[1]) ? (filteredDataX[1]) : (readDataX[1] + filteredDataX[1]);
    assign writeDataX[2] = (rowCount[0] & pixelCount[2]) ? (filteredDataX[2]) : (readDataX[2] + filteredDataX[2]);
    assign writeDataX[3] = (rowCount[1] & pixelCount[0]) ? (filteredDataX[3]) : (readDataX[3] + filteredDataX[3]);
    assign writeDataX[4] = (rowCount[1] & pixelCount[1]) ? (filteredDataX[4]) : (readDataX[4] + filteredDataX[4]);
    assign writeDataX[5] = (rowCount[1] & pixelCount[2]) ? (filteredDataX[5]) : (readDataX[5] + filteredDataX[5]);
    assign writeDataX[6] = (rowCount[2] & pixelCount[0]) ? (filteredDataX[6]) : (readDataX[6] + filteredDataX[6]);
    assign writeDataX[7] = (rowCount[2] & pixelCount[1]) ? (filteredDataX[7]) : (readDataX[7] + filteredDataX[7]);
    assign writeDataX[8] = (rowCount[2] & pixelCount[2]) ? (filteredDataX[8]) : (readDataX[8] + filteredDataX[8]);

    wire[15:0] resultx1  = camData;
    wire[15:0] resultx2  = camData << 1;
    wire[15:0] resultx_1 = ~camData + 1;
    wire[15:0] resultx_2 = ~(camData << 1) + 1;   

    wire[15:0] filteredDataY[0:8];

    /* assign writeDataY[0] = readDataY[0] & {16{~rowCount[0] & ~pixelCount[0]}} + filteredDataY[0];
    assign writeDataY[1] = readDataY[1] & {16{~rowCount[0] & ~pixelCount[1]}} + filteredDataY[1];
    assign writeDataY[2] = readDataY[2] & {16{~rowCount[0] & ~pixelCount[2]}} + filteredDataY[2];
    assign writeDataY[3] = readDataY[3] & {16{~rowCount[1] & ~pixelCount[0]}} + filteredDataY[3];
    assign writeDataY[4] = readDataY[4] & {16{~rowCount[1] & ~pixelCount[1]}} + filteredDataY[4];
    assign writeDataY[5] = readDataY[5] & {16{~rowCount[1] & ~pixelCount[2]}} + filteredDataY[5];
    assign writeDataY[6] = readDataY[6] & {16{~rowCount[2] & ~pixelCount[0]}} + filteredDataY[6];
    assign writeDataY[7] = readDataY[7] & {16{~rowCount[2] & ~pixelCount[1]}} + filteredDataY[7];
    assign writeDataY[8] = readDataY[8] & {16{~rowCount[2] & ~pixelCount[2]}} + filteredDataY[8]; */

    assign writeDataY[0] = (rowCount[0] & pixelCount[0]) ? (filteredDataY[0]) : (readDataY[0] + filteredDataY[0]);
    assign writeDataY[1] = (rowCount[0] & pixelCount[1]) ? (filteredDataY[1]) : (readDataY[1] + filteredDataY[1]);
    assign writeDataY[2] = (rowCount[0] & pixelCount[2]) ? (filteredDataY[2]) : (readDataY[2] + filteredDataY[2]);
    assign writeDataY[3] = (rowCount[1] & pixelCount[0]) ? (filteredDataY[3]) : (readDataY[3] + filteredDataY[3]);
    assign writeDataY[4] = (rowCount[1] & pixelCount[1]) ? (filteredDataY[4]) : (readDataY[4] + filteredDataY[4]);
    assign writeDataY[5] = (rowCount[1] & pixelCount[2]) ? (filteredDataY[5]) : (readDataY[5] + filteredDataY[5]);
    assign writeDataY[6] = (rowCount[2] & pixelCount[0]) ? (filteredDataY[6]) : (readDataY[6] + filteredDataY[6]);
    assign writeDataY[7] = (rowCount[2] & pixelCount[1]) ? (filteredDataY[7]) : (readDataY[7] + filteredDataY[7]);
    assign writeDataY[8] = (rowCount[2] & pixelCount[2]) ? (filteredDataY[8]) : (readDataY[8] + filteredDataY[8]);

    //mega wire
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

    // Sobel X

    assign filteredDataX[0] = (pixelCount[0] & (rowCount[0] | rowCount[2])) ? resultx_1 : 
                                (pixelCount[2] & (rowCount[0] | rowCount[2])) ? resultx1 : 
                                  (rowCount[1] & pixelCount[0]) ? resultx_2 :
                                    (rowCount[1] & pixelCount[2]) ? resultx2 : 16'b0;
    
    assign filteredDataX[1] = (pixelCount[1] & (rowCount[0] | rowCount[2])) ? resultx_1 : 
                                (pixelCount[0] & (rowCount[0] | rowCount[2])) ? resultx1 : 
                                  (rowCount[1] & pixelCount[1]) ? resultx_2 :
                                    (rowCount[1] & pixelCount[0]) ? resultx2 : 16'b0;
    
    assign filteredDataX[2] = (pixelCount[2] & (rowCount[0] | rowCount[2])) ? resultx_1 : 
                                (pixelCount[1] & (rowCount[0] | rowCount[2])) ? resultx1 : 
                                  (rowCount[1] & pixelCount[2]) ? resultx_2 :
                                    (rowCount[1] & pixelCount[1]) ? resultx2 : 16'b0;

    assign filteredDataX[3] = (pixelCount[0] & (rowCount[1] | rowCount[0])) ? resultx_1 : 
                                (pixelCount[2] & (rowCount[1] | rowCount[0])) ? resultx1 : 
                                  (rowCount[2] & pixelCount[0]) ? resultx_2 :
                                    (rowCount[2] & pixelCount[2]) ? resultx2 : 16'b0;
    
    assign filteredDataX[4] = (pixelCount[1] & (rowCount[1] | rowCount[0])) ? resultx_1 : 
                                (pixelCount[0] & (rowCount[1] | rowCount[0])) ? resultx1 : 
                                  (rowCount[2] & pixelCount[1]) ? resultx_2 :
                                    (rowCount[2] & pixelCount[0]) ? resultx2 : 16'b0;
    
    assign filteredDataX[5] = (pixelCount[2] & (rowCount[1] | rowCount[0])) ? resultx_1 : 
                                (pixelCount[1] & (rowCount[1] | rowCount[0])) ? resultx1 : 
                                  (rowCount[2] & pixelCount[2]) ? resultx_2 :
                                    (rowCount[2] & pixelCount[1]) ? resultx2 : 16'b0;

    assign filteredDataX[6] = (pixelCount[0] & (rowCount[2] | rowCount[1])) ? resultx_1 : 
                                (pixelCount[2] & (rowCount[2] | rowCount[1])) ? resultx1 : 
                                  (rowCount[0] & pixelCount[0]) ? resultx_2 :
                                    (rowCount[0] & pixelCount[2]) ? resultx2 : 16'b0;
    
    assign filteredDataX[7] = (pixelCount[1] & (rowCount[2] | rowCount[1])) ? resultx_1 : 
                                (pixelCount[0] & (rowCount[2] | rowCount[1])) ? resultx1 : 
                                  (rowCount[0] & pixelCount[1]) ? resultx_2 :
                                    (rowCount[0] & pixelCount[0]) ? resultx2 : 16'b0;
    
    assign filteredDataX[8] = (pixelCount[2] & (rowCount[2] | rowCount[1])) ? resultx_1 : 
                                (pixelCount[1] & (rowCount[2] | rowCount[1])) ? resultx1 : 
                                  (rowCount[0] & pixelCount[2]) ? resultx_2 :
                                    (rowCount[0] & pixelCount[1]) ? resultx2 : 16'b0;

    // Sobel Y

    assign filteredDataY[0] = (rowCount[0] & (pixelCount[0] | pixelCount[2])) ? resultx1 :
                                (rowCount[2] & (pixelCount[0] | pixelCount[2])) ? resultx_1 : 
                                  (rowCount[2] & pixelCount[1]) ? resultx_2 : 
                                    (rowCount[0] & pixelCount[1]) ? resultx2 : 16'b0;

    assign filteredDataY[1] = (rowCount[0] & (pixelCount[1] | pixelCount[0])) ? resultx1 :
                                (rowCount[2] & (pixelCount[1] | pixelCount[0])) ? resultx_1 : 
                                  (rowCount[2] & pixelCount[2]) ? resultx_2 : 
                                    (rowCount[0] & pixelCount[2]) ? resultx2 : 16'b0;

    assign filteredDataY[2] = (rowCount[0] & (pixelCount[2] | pixelCount[1])) ? resultx1 :
                                (rowCount[2] & (pixelCount[2] | pixelCount[1])) ? resultx_1 : 
                                  (rowCount[2] & pixelCount[0]) ? resultx_2 : 
                                    (rowCount[0] & pixelCount[0]) ? resultx2 : 16'b0;

    assign filteredDataY[3] = (rowCount[1] & (pixelCount[0] | pixelCount[2])) ? resultx1 :
                                (rowCount[0] & (pixelCount[0] | pixelCount[2])) ? resultx_1 : 
                                  (rowCount[0] & pixelCount[1]) ? resultx_2 : 
                                    (rowCount[1] & pixelCount[1]) ? resultx2 : 16'b0;

    assign filteredDataY[4] = (rowCount[1] & (pixelCount[1] | pixelCount[0])) ? resultx1 :
                                (rowCount[0] & (pixelCount[1] | pixelCount[0])) ? resultx_1 : 
                                  (rowCount[0] & pixelCount[2]) ? resultx_2 : 
                                    (rowCount[1] & pixelCount[2]) ? resultx2 : 16'b0;

    assign filteredDataY[5] = (rowCount[1] & (pixelCount[2] | pixelCount[1])) ? resultx1 :
                                (rowCount[0] & (pixelCount[2] | pixelCount[1])) ? resultx_1 : 
                                  (rowCount[0] & pixelCount[0]) ? resultx_2 : 
                                    (rowCount[1] & pixelCount[0]) ? resultx2 : 16'b0;      

    assign filteredDataY[6] = (rowCount[2] & (pixelCount[0] | pixelCount[2])) ? resultx1 :
                                (rowCount[1] & (pixelCount[0] | pixelCount[2])) ? resultx_1 : 
                                  (rowCount[1] & pixelCount[1]) ? resultx_2 : 
                                    (rowCount[2] & pixelCount[1]) ? resultx2 : 16'b0;

    assign filteredDataY[7] = (rowCount[2] & (pixelCount[1] | pixelCount[0])) ? resultx1 :
                                (rowCount[1] & (pixelCount[1] | pixelCount[0])) ? resultx_1 : 
                                  (rowCount[1] & pixelCount[2]) ? resultx_2 : 
                                    (rowCount[2] & pixelCount[2]) ? resultx2 : 16'b0;

    assign filteredDataY[8] = (rowCount[2] & (pixelCount[2] | pixelCount[1])) ? resultx1 :
                                (rowCount[1] & (pixelCount[2] | pixelCount[1])) ? resultx_1 : 
                                  (rowCount[1] & pixelCount[0]) ? resultx_2 : 
                                    (rowCount[2] & pixelCount[0]) ? resultx2 : 16'b0;                          

    localparam S0  = 3'b001;
    localparam S1  = 3'b010;
    localparam S2  = 3'b100;

    reg[2:0] pixelCount, nextStateP;
    reg[2:0] rowCount, nextStateR;

    always @* begin
        case(pixelCount)
            S0:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S1 : S0;
            S1:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S2 : S1; 
            S2:         nextStateP <= (hsync == 1'b1 || vsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S0 : S2;
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
    
    reg[10:0] writeBufferReg;

    always @(posedge camClock) begin
        writeBufferReg <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 11'b0 : (validCamera == 1'b1) ? writeBufferReg + 11'd1 : writeBufferReg;
    end

    wire bufferEnable = (writeBufferReg[4:0] == 5'b11111) ? validCamera: 1'b0;

    reg[31:0] s2pReg;

    always @(posedge camClock) begin
        s2pReg <= (reset == 1'b1 || hsync == 1'b1 || vsync == 1'b1) ? 32'b0 : (validCamera == 1'b1) ? {s2pReg[30:0], finalOutput} : s2pReg;
    end

    dualPortRam2k lineBuffer (.address1({3'b000, writeBufferReg[10:5]}),
                                .address2(memoryAddressReg),
                                .clock1(camClock),
                                .clock2(clock),
                                .writeEnable(bufferEnable),
                                .dataIn1(s2pReg),
                                .dataOut2(busOutput));

    //clock2

    wire[31:0] busOutput;

    reg[2:0] stateReg, nextState;  
    localparam IDLE     = 3'd0;
    localparam REQUEST  = 3'd1;
    localparam INIT     = 3'd2;
    localparam CLOSE    = 3'd3;
    localparam WRITE    = 3'd4;
    localparam ERROR    = 3'd5;

    wire newScreen, newLine;
    reg [31:0] busAddressReg, addressDataOutReg;
    reg [8:0] pixelPerLineReg;
    reg [8:0] memoryAddressReg;
    reg dataValidReg;
    reg [8:0] burstCountReg;
    wire isWriting = ((stateReg == WRITE) && burstCountReg[8] == 1'b0) ? ~busyIn : 1'b0;
    wire [31:0] busAddressNext = (reset == 1'b1 || newScreen == 1'b1) ? busStartReg : 
                                    (isWriting == 1'b1) ? busAddressReg + 32'd4 : busAddressReg;
    wire [7:0] burstSizeNext = ((stateReg == INIT) && pixelPerLineReg > 9'd16) ? 8'd16 : pixelPerLineReg[7:0];
    
    assign requestBus        = (stateReg == REQUEST) ? 1'b1 : 1'b0;
    assign addressDataOut    = addressDataOutReg;
    assign dataValidOut      = dataValidReg;
    
    always @* begin
        case (stateReg)
            IDLE        : nextState <= ((statusReg[0] == 1'b1) && newLine == 1'b1) ? REQUEST : IDLE; 
            REQUEST     : nextState <= (busGrant == 1'b1) ? INIT : REQUEST;
            INIT        : nextState <= WRITE;
            WRITE       : nextState <= (busErrorIn == 1'b1) ? ERROR :
                                            (burstCountReg[8] == 1'b1 && busyIn == 1'b0) ? CLOSE : WRITE;
            CLOSE       : nextState <= (pixelPerLineReg != 9'd0) ? REQUEST : IDLE;
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
        burstSizeOut            <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 8'd0;
        burstCountReg           <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 
                                        (isWriting == 1'b1) ? burstCountReg - 9'd1 : burstCountReg;
        memoryAddressReg          <= (stateReg == IDLE) ? 9'd0 : 
                                        (isWriting == 1'b1) ? memoryAddressReg + 9'd1 : memoryAddressReg;
        pixelPerLineReg         <= (newLine == 1'b1) ? 8'd20 :
                                        (stateReg == INIT) ? pixelPerLineReg - {1'b0, burstSizeNext} : pixelPerLineReg;
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