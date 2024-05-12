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
    input wire         busyIn, busErrorIn
);

    reg[31:0] busStartReg;
    reg[9:0] blockSizeReg;
    reg[8:0] burstSizeReg;
    reg[15:0] thresholdReg;
    reg[1:0] transferModeReg;
    reg[1:0] statusReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;
    
    assign ciDone = validInstr;
    assign ciResult = (validInstr == 1'b0 || ciValueA[9] == 1'b1) ? 32'b0 : 
                            (ciValueA[12:10] == 3'b001) ? busStartReg : 
                                (ciValueA[12:10] == 3'b010) ? blockSizeReg : 
                                    (ciValueA[12:10] == 3'b011) ? burstSizeReg :
                                        (ciValueA[12:10] == 3'b100) ? thresholdReg :
                                            (ciValueA[12:10] == 3'b101) ? statusReg : 32'b0; 

    always @ (posedge camClock) begin
        busStartReg <= (reset == 1'b1) ? 32'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0011) ? ciValueB : busStartReg;
        blockSizeReg <= (reset == 1'b1) ? 10'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0101) ? ciValueB[9:0] : blockSizeReg;
        burstSizeReg <= (reset == 1'b1) ? 9'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0111) ? ciValueB[7:0] : burstSizeReg;
        thresholdReg <= (reset == 1'b1) ? 16'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1001) ? ciValueB[15:0] : thresholdReg;
        transferModeReg <= (reset == 1'b1) ? 2'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011) ? ciValueB[1:0] : transferModeReg;
    end

    reg[7:0] addressReg [0:8];
    wire [7:0] address [0:8];
    wire [15:0] writeData [0:8];
    wire [15:0] readData [0:8];

    genvar j;
    generate
        for(j = 0; j < 9; j = j + 1) begin : wire_address
            assign address[j] = addressReg[j];
        end
    endgenerate


    genvar i;
    generate
        for(i = 0; i < 9; i = i + 1) begin : bufferX_instantiation
            sobelBuffer  buffer(.addressIn(address[i]), .addressOut(address[i]), 
                                    .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                        .dataIn(writeData[i]), .dataOut(readData[i]));
        end
    endgenerate

    genvar k;
    generate
        for(k = 0; k < 9; k = k + 1) begin : bufferY_instantiation
            sobelBuffer  buffer(.addressIn(address[k]), .addressOut(address[k]), 
                                    .clockA(camClock), .clockB(~camClock), .writeEnable(validCamera), 
                                        .dataIn(writeData[k]), .dataOut(readData[k]));
        end
    endgenerate  
    
    wire firstTriplet = count3pixels[2] & count3pixels[1] & count3pixels[0];
    wire firstTrirows = count3rows[2] & count3rows[1] & count3rows[0];

    wire[7:0] s_writeAddress [0:8];

    assign s_writeAddress[0] = addressReg[0] + (pixelCount[0] & rowCount[0] & firstTriplet);
    assign s_writeAddress[1] = addressReg[1] + (pixelCount[1] & rowCount[0] & firstTriplet);
    assign s_writeAddress[2] = addressReg[2] + (pixelCount[2] & rowCount[0] & firstTriplet);
    assign s_writeAddress[3] = addressReg[3] + (pixelCount[0] & rowCount[1] & firstTriplet);
    assign s_writeAddress[4] = addressReg[4] + (pixelCount[1] & rowCount[1] & firstTriplet);
    assign s_writeAddress[5] = addressReg[5] + (pixelCount[2] & rowCount[1] & firstTriplet);
    assign s_writeAddress[6] = addressReg[6] + (pixelCount[0] & rowCount[2] & firstTriplet);
    assign s_writeAddress[7] = addressReg[7] + (pixelCount[1] & rowCount[2] & firstTriplet);
    assign s_writeAddress[8] = addressReg[8] + (pixelCount[2] & rowCount[2] & firstTriplet);

    always @(posedge camClock) begin
        addressReg[0] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[0] : addressReg[0];
        addressReg[1] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[1] : addressReg[1];
        addressReg[2] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[2] : addressReg[2];
        addressReg[3] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[3] : addressReg[3];
        addressReg[4] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[4] : addressReg[4];
        addressReg[5] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[5] : addressReg[5];
        addressReg[6] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[6] : addressReg[6];
        addressReg[7] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[7] : addressReg[7];
        addressReg[8] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : (validCamera == 1'b1) ? s_writeAddress[8] : addressReg[8];
    end      

    reg[2:0] count3pixels, count3rows;

    always @(posedge camClock) begin
        count3pixels <= (reset == 1'b1 || hsync == 1'b1) ? 3'b0 : (validCamera == 1'b1) ? 
                                {count3pixels[1:0], 1'b1} : count3pixels;
        count3rows <= (reset == 1'b1 || vsync == 1'b1) ? 3'b0 : (hsync == 1'b1) ? 
                                {count3rows[1:0], 1'b1} : count3rows;                        
    end

    reg[15:0] filteredData[0:8];

    assign writeData[0] = readData[0] & {16{~rowCount[0] & ~pixelCount[0]}} + filteredData[0];
    assign writeData[1] = readData[1] & {16{~rowCount[0] & ~pixelCount[1]}} + filteredData[1];
    assign writeData[2] = readData[2] & {16{~rowCount[0] & ~pixelCount[2]}} + filteredData[2];
    assign writeData[3] = readData[3] & {16{~rowCount[1] & ~pixelCount[0]}} + filteredData[3];
    assign writeData[4] = readData[4] & {16{~rowCount[1] & ~pixelCount[1]}} + filteredData[4];
    assign writeData[5] = readData[5] & {16{~rowCount[1] & ~pixelCount[2]}} + filteredData[5];
    assign writeData[6] = readData[6] & {16{~rowCount[2] & ~pixelCount[0]}} + filteredData[6];
    assign writeData[7] = readData[7] & {16{~rowCount[2] & ~pixelCount[1]}} + filteredData[7];
    assign writeData[8] = readData[8] & {16{~rowCount[2] & ~pixelCount[2]}} + filteredData[8];

    wire[15:0] resultx1  = camData;
    wire[15:0] resultx2  = camData << 1;
    wire[15:0] resultx_1 = ~camData + 1;
    wire[15:0] resultx_2 = ~(camData << 1) + 1; 

    
    //mega wire
    wire[15:0] outputX =    writeData[0] & {16{rowCount[2] & pixelCount[2]}} |
                            writeData[1] & {16{rowCount[2] & pixelCount[0]}} |
                            writeData[2] & {16{rowCount[2] & pixelCount[1]}} |
                            writeData[3] & {16{rowCount[0] & pixelCount[2]}} |
                            writeData[4] & {16{rowCount[0] & pixelCount[0]}} |
                            writeData[5] & {16{rowCount[0] & pixelCount[1]}} |
                            writeData[6] & {16{rowCount[1] & pixelCount[2]}} |
                            writeData[7] & {16{rowCount[1] & pixelCount[0]}} |
                            writeData[8] & {16{rowCount[1] & pixelCount[1]}}; 

    // MEM 0
    always @* begin
        if((rowCount[0] & pixelCount[0]) | rowCount[2] & pixelCount[0]) begin
                filteredData[0] = resultx_1;
        end else if((rowCount[0] & pixelCount[2]) | (rowCount[2] & pixelCount[2])) begin
                filteredData[0] = resultx1;
        end else if(rowCount[1] & pixelCount[0]) begin
                filteredData[0] = resultx_2;
        end else if(rowCount[1] & pixelCount[2]) begin
                filteredData[0] = resultx2;
        end else begin
                filteredData[0] = 16'd0;
        end
    end

    // MEM 1
    always @(*) begin
        if((rowCount[0] & pixelCount[1]) | rowCount[2] & pixelCount[1]) begin
                filteredData[1] = resultx_1;
        end else if((rowCount[0] & pixelCount[0]) | (rowCount[2] & pixelCount[0])) begin
                filteredData[1] = resultx1;
        end else if(rowCount[1] & pixelCount[1]) begin
                filteredData[1] = resultx_2;
        end else if(rowCount[1] & pixelCount[0]) begin
                filteredData[1] = resultx2;
        end else begin
                filteredData[1] = 16'd0;
        end        
    end

    // MEM 2
    always @(*) begin
        if((rowCount[0] & pixelCount[2]) | rowCount[2] & pixelCount[2]) begin
                filteredData[2] = resultx_1;
        end else if((rowCount[0] & pixelCount[1]) | (rowCount[2] & pixelCount[1])) begin
                filteredData[2] = resultx1;
        end else if(rowCount[1] & pixelCount[2]) begin
                filteredData[2] = resultx_2;
        end else if(rowCount[1] & pixelCount[1]) begin
                filteredData[2] = resultx2;
        end else begin
                filteredData[2] = 16'd0;
        end        
    end

    // MEM 3
    always @* begin
        if((rowCount[1] & pixelCount[0]) | rowCount[0] & pixelCount[0]) begin
                filteredData[3] = resultx_1;
        end else if((rowCount[1] & pixelCount[2]) | (rowCount[0] & pixelCount[2])) begin
                filteredData[3] = resultx1;
        end else if(rowCount[2] & pixelCount[0]) begin
                filteredData[3] = resultx_2;
        end else if(rowCount[2] & pixelCount[2]) begin
                filteredData[3] = resultx2;
        end else begin
                filteredData[3] = 16'd0;
        end
    end

    // MEM 4
    always @(*) begin
        if((rowCount[1] & pixelCount[1]) | rowCount[0] & pixelCount[1]) begin
                filteredData[4] = resultx_1;
        end else if((rowCount[1] & pixelCount[0]) | (rowCount[0] & pixelCount[0])) begin
                filteredData[4] = resultx1;
        end else if(rowCount[2] & pixelCount[1]) begin
                filteredData[4] = resultx_2;
        end else if(rowCount[2] & pixelCount[0]) begin
                filteredData[4] = resultx2;
        end else begin
                filteredData[4] = 16'd0;
        end        
    end

    // MEM 5
    always @(*) begin
        if((rowCount[1] & pixelCount[2]) | rowCount[0] & pixelCount[2]) begin
                filteredData[5] = resultx_1;
        end else if((rowCount[1] & pixelCount[1]) | (rowCount[0] & pixelCount[1])) begin
                filteredData[5] = resultx1;
        end else if(rowCount[2] & pixelCount[2]) begin
                filteredData[5] = resultx_2;
        end else if(rowCount[2] & pixelCount[1]) begin
                filteredData[5] = resultx2;
        end else begin
                filteredData[5] = 16'd0;
        end        
    end

    // MEM 6
    always @* begin
        if((rowCount[2] & pixelCount[0]) | rowCount[1] & pixelCount[0]) begin
                filteredData[6] = resultx_1;
        end else if((rowCount[2] & pixelCount[2]) | (rowCount[1] & pixelCount[2])) begin
                filteredData[6] = resultx1;
        end else if(rowCount[0] & pixelCount[0]) begin
                filteredData[6] = resultx_2;
        end else if(rowCount[0] & pixelCount[2]) begin
                filteredData[6] = resultx2;
        end else begin
                filteredData[6] = 16'd0;
        end
    end

    // MEM 7
    always @(*) begin
        if((rowCount[2] & pixelCount[1]) | rowCount[1] & pixelCount[1]) begin
                filteredData[7] = resultx_1;
        end else if((rowCount[2] & pixelCount[0]) | (rowCount[1] & pixelCount[0])) begin
                filteredData[7] = resultx1;
        end else if(rowCount[0] & pixelCount[1]) begin
                filteredData[7] = resultx_2;
        end else if(rowCount[0] & pixelCount[0]) begin
                filteredData[7] = resultx2;
        end else begin
                filteredData[7] = 16'd0;
        end        
    end

    // MEM 8
    always @(*) begin
        if((rowCount[2] & pixelCount[2]) | rowCount[1] & pixelCount[2]) begin
                filteredData[8] = resultx_1;
        end else if((rowCount[2] & pixelCount[1]) | (rowCount[1] & pixelCount[1])) begin
                filteredData[8] = resultx1;
        end else if(rowCount[0] & pixelCount[2]) begin
                filteredData[8] = resultx_2;
        end else if(rowCount[0] & pixelCount[1]) begin
                filteredData[8] = resultx2;
        end else begin
                filteredData[8] = 16'd0;
        end        
    end

    localparam S0  = 3'b001;
    localparam S1  = 3'b010;
    localparam S2  = 3'b100;

    reg[2:0] pixelCount, nextStateP;
    reg[2:0] rowCount, nextStateR;

    always @* begin
        case(pixelCount)
            S0:         nextStateP <= (hsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S1 : S0;
            S1:         nextStateP <= (hsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S2 : S1; 
            S2:         nextStateP <= (hsync == 1'b1) ? S0 : (validCamera == 1'b1)  ? S0 : S2;
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
        pixelCount <= (reset == 1'b1) ? S0 : nextStateR;
    end

    //divertimento per theo
    wire startLine = firstTrirows & (addressReg[0] == 8'b0 || addressReg[3] == 8'b0 || addressReg[3] == 8'b0) & rowCount[2] & pixelCount[2];
    
    reg[10:0] writeBufferReg;

    always @(posedge camClock) begin
        writeBufferReg <= (reset == 1'b1 || hsync == 1'b1) ? 11'b0 : (validCamera == 1'b1) ? writeBufferReg + 11'd1 : writeBufferReg;
    end

    wire[31:0] fourSobelPixels = {finalOutput, pixel1Reg, pixel2Reg, pixel3Reg};
    reg [7:0] pixel1Reg, pixel2Reg,pixel3Reg;
    wire bufferEnable = (writeBufferReg[1:0] == 2'b11) ? validCamera : 1'b0;

    always @(posedge camClock) begin
        pixel3Reg <= (writeBufferReg[1:0] == 2'b00 && validCamera == 1'b1) ? finalOutput : pixel3Reg;
        pixel2Reg <= (writeBufferReg[1:0] == 2'b01 && validCamera == 1'b1) ? finalOutput : pixel2Reg;
        pixel1Reg <= (writeBufferReg[1:0] == 2'b10 && validCamera == 1'b1) ? finalOutput : pixel1Reg;
    end

    dualPortRam2k lineBuffer (.address1(writeBufferReg[10:2]),
                                .address2(memoryAddressReg),
                                .clock1(camClock),
                                .clock2(clock),
                                .writeEnable(bufferEnable),
                                .dataIn1(fourSobelPixels),
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
            IDLE        : nextState <= ((transferModeReg[1] == 1'b1 || transferModeReg[0] == 1'b1) && newLine == 1'b1) ? REQUEST : IDLE; 
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
        busAddressReg           <= busAddressNext;
        stateReg                <= (reset == 1'b1) ? IDLE : nextState;
        beginTransactionOut     <= (stateReg == INIT) ? 1'd1 : 1'd0;
        byteEnablesOut          <= (stateReg == INIT) ? 4'hF : 4'd0;
        addressDataOutReg       <= (stateReg == INIT) ? busAddressReg : 
                                        (isWriting == 1'b1) ? busOutput : 
                                            (busyIn == 1'b1) ? addressDataOutReg : 32'd0;
        dataValidReg            <= (isWriting == 1'b1) ? 1'b1 : 
                                        (busyIn == 1'b1) ? dataValidReg : 1'b0;
        endTransactionOut       <= (stateReg == CLOSE || stateReg == ERROR) ? 1'b1 : 1'b0;
        burstSizeOut            <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 8'd0;
        burstCountReg           <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 
                                        (isWriting == 1'b1) ? burstCountReg - 9'd1 : burstCountReg;
        memoryAddressReg          <= (stateReg == IDLE) ? 9'd0 : 
                                        (isWriting == 1'b1) ? memoryAddressReg + 9'd1 : memoryAddressReg;
        pixelPerLineReg         <= (newLine == 1'b1) ? 8'b0 : //da modificare per mettere counter dei pxel per riga
                                        (stateReg == INIT) ? pixelPerLineReg - {1'b0, burstSizeNext} : pixelPerLineReg;

    synchroFlop sns (.clockIn(camClock),
                    .clockOut(clock),
                    .reset(reset),
                    .D(vsync),
                    .Q(newScreen));
  
    synchroFlop snl (.clockIn(camClock),
                    .clockOut(clock),
                    .reset(reset),
                    .D(startLine),
                    .Q(newLine));

    end

endmodule