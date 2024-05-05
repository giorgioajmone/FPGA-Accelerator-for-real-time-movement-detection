module sobelAccelerator #(parameter [7:0] customId = 8'd0) (
    input wire         clock, reset, hsync, vsync, ciStart, validCamera,
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

    //no idea ssolutamente da fixare
    reg[7:0] writeAddress [0:8];
    reg[7:0] readAddress [0:8];
    wire writeEnable [0:8];
    reg [15:0] writeData [0:8];
    reg [15:0] readData [0:8];

    genvar i;
    generate
        for(i = 0; i < 9; i = i + 1) begin : buffer_instantiation
            sobelBuffer  buffer(.addressIn(writeAddress[i]), .addressOut(readAddress[i]), 
                            .clockA(clock), .clockB(~clock), .writeEnable(validCamera), 
                                .dataIn(writeData[i]), .dataOut(readData[i]));
        end
    endgenerate  

    reg[31:0] busStartReg;
    reg[9:0] blockSizeReg;
    reg[8:0] burstSizeReg;
    reg[15:0] thresholdReg;
    reg[1:0] transferModeReg;
    reg[1:0] staturReg;

    wire validInstr = (ciN == customId) ? ciStart : 1'b0;

    assign ciResult = (validInstr == 1'b0 || ciValueA[9] == 1'b1) ? 32'b0 : 
                            (ciValueA[12:10] == 3'b001) ? busStartReg : 
                                (ciValueA[12:10] == 3'b010) ? blockSizeReg : 
                                    (ciValueA[12:10] == 3'b011) ? burstSizeReg :
                                        (ciValueA[12:10] == 3'b100) ? thresholdReg :
                                            (ciValueA[12:10] == 3'b101) ? staturReg : 32'b0; 

    always @ (posedge clock) begin
        busStartReg <= (reset == 1'b1) ? 32'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0011) ? ciValueB : busStartReg;
        blockSizeReg <= (reset == 1'b1) ? 10'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0101) ? ciValueB[9:0] : blockSizeReg;
        burstSizeReg <= (reset == 1'b1) ? 9'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b0111) ? ciValueB[7:0] : burstSizeReg;
        thresholdReg <= (reset == 1'b1) ? 16'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1001) ? ciValueB[15:0] : thresholdReg;
        transferModeReg <= (reset == 1'b1) ? 2'b0 : (validInstr == 1'b1 && ciValueA[12:9] == 4'b1011) ? ciValueB[1:0] : transferModeReg;
    end

    reg [10:0] hConvReg, vConvReg;
    reg[1:0] indexes [0:8];
    reg[2:0] overwriteReg, readyReg;

    always @(posedge clock) begin
            hConvReg <= (reset == 1'b1 || vsync == 1'b1 || hsync == 1'b1) ? 11'd0 : (validCamera == 1'b1) ? hConvReg + 11'd1 : hConvReg;
            vConvReg <= (reset == 1'b1 || vsync == 1'b1) ? 11'd0 : (hsync == 1'b1) ? vConvReg + 11'd1 : vConvReg;
            overwriteReg <= (reset == 1'b1 || vsync == 1'b1) ? 3'b001 : (vsync == 1'b1) ? {overwriteReg[1:0], overwriteReg[2]} : overwriteReg;

            indexes[0] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd0 : (hsync == 1'b1) ? indexes[7] : (validCamera == 1'b1) ? indexes[3] : indexes[0]; 
            indexes[1] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd1 : (hsync == 1'b1) ? indexes[8] : (validCamera == 1'b1) ? indexes[4] : indexes[1];
            indexes[2] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd2 : (hsync == 1'b1) ? indexes[6] : (validCamera == 1'b1) ? indexes[5] : indexes[2];
            indexes[3] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd3 : (hsync == 1'b1) ? indexes[1] : (validCamera == 1'b1) ? indexes[6] : indexes[3];
            indexes[4] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd4 : (hsync == 1'b1) ? indexes[2] : (validCamera == 1'b1) ? indexes[7] : indexes[4];
            indexes[5] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd5 : (hsync == 1'b1) ? indexes[0] : (validCamera == 1'b1) ? indexes[8] : indexes[5];
            indexes[6] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd6 : (hsync == 1'b1) ? indexes[4] : (validCamera == 1'b1) ? indexes[0] : indexes[6];
            indexes[7] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd7 : (hsync == 1'b1) ? indexes[5] : (validCamera == 1'b1) ? indexes[1] : indexes[7];
            indexes[8] <= (reset == 1'b1 || vsync == 1'b1) ? 3'd8 : (hsync == 1'b1) ? indexes[3] : (validCamera == 1'b1) ? indexes[2] : indexes[8];
    end

    //da ottimizzare per ale
    wire[7:0] pAddress = (hConvReg - 1) / 3;
    wire[7:0] Address = (hConvReg) / 3;
    wire[7:0] sAddress = (hConvReg + 1) / 3;

    always @* begin 
        writeAddress[indexes[0]] = pAddress;
        writeAddress[indexes[1]] = pAddress;
        writeAddress[indexes[2]] = pAddress;
        writeAddress[indexes[3]] = Address;
        writeAddress[indexes[4]] = Address;
        writeAddress[indexes[5]] = Address;
        writeAddress[indexes[6]] = sAddress;
        writeAddress[indexes[7]] = sAddress;
        writeAddress[indexes[8]] = sAddress;

        readAddress[indexes[0]] = pAddress;
        readAddress[indexes[1]] = pAddress;
        readAddress[indexes[2]] = pAddress;
        readAddress[indexes[3]] = Address;
        readAddress[indexes[4]] = Address;
        readAddress[indexes[5]] = Address;
        readAddress[indexes[6]] = sAddress;
        readAddress[indexes[7]] = sAddress;
        readAddress[indexes[8]] = sAddress;

        writeData[indexes[0]] = readData[indexes[0]] * overwriteReg[0] + camData * (1);
        writeData[indexes[1]] = readData[indexes[1]] * overwriteReg[1] + camData * (2);
        writeData[indexes[2]] = readData[indexes[2]] * overwriteReg[2] + camData * (1);
        writeData[indexes[3]] = readData[indexes[3]] * overwriteReg[0] + camData * (0);
        writeData[indexes[4]] = readData[indexes[4]] * overwriteReg[1] + camData * (0);
        writeData[indexes[5]] = readData[indexes[5]] * overwriteReg[2] + camData * (0);
        writeData[indexes[6]] = readData[indexes[6]] * overwriteReg[0] + camData * (-1);
        writeData[indexes[7]] = readData[indexes[7]] * overwriteReg[1] + camData * (-2);
        writeData[indexes[8]] = readData[indexes[8]] * overwriteReg[2] + camData * (-1);
    end 

    
    //per salvare quello che è stato completato readData[indexes[0]]
    wire[31:0] s_busPixelWord;

    dualPortRam2k lineBuffer (.address1(hConvReg[10:2]),
                             .address2(memoryAddressReg),
                             .clock1(clock),
                             .clock2(clock),
                             .writeEnable(1'b1),
                             .dataIn(readData[indexes[0]]),
                             .dataOut2(s_busPixelWord));

    //quando controlliamo il bus dobbiamo mettere 3 linee di delay rispetto a new screen

    reg delayHSYNC, delayVSYNC;
    reg[10:0] delayHCounter, delayVCounter;



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
    wire [31:0] busAddressNext = (reset == 1'b1 || vsync == 1'b1) ? busStartReg : 
                                    (isWriting == 1'b1) ? busAddressReg + 32'd4 : busAddressReg;
    wire [7:0] burstSizeNext = ((stateReg == INIT) && pixelPerLineReg > 9'd16) ? 8'd16 : pixelPerLineReg[7:0];
    
    assign requestBus        = (stateReg == REQUEST) ? 1'b1 : 1'b0;
    assign addressDataOut    = addressDataOutReg;
    assign dataValidOut      = dataValidReg;
    
    always @* begin
        case (stateReg)
            IDLE        : nextState <= ((transferModeReg[1] == 1'b1 || transferModeReg[0] == 1'b1) && hsync == 1'b1) ? REQUEST : IDLE; 
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
                                        (isWriting == 1'b1) ? s_busPixelWord : 
                                            (busyIn == 1'b1) ? addressDataOutReg : 32'd0;
        dataValidReg            <= (isWriting == 1'b1) ? 1'b1 : 
                                        (busyIn == 1'b1) ? dataValidReg : 1'b0;
        endTransactionOut       <= (stateReg == CLOSE || stateReg == ERROR) ? 1'b1 : 1'b0;
        burstSizeOut            <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 8'd0;
        burstCountReg           <= (stateReg == INIT) ? burstSizeNext - 8'd1 : 
                                        (isWriting == 1'b1) ? burstCountReg - 9'd1 : burstCountReg;
        memoryAddressReg          <= (stateReg == IDLE) ? 9'd0 : 
                                        (isWriting == 1'b1) ? memoryAddressReg + 9'd1 : memoryAddressReg;
        pixelPerLineReg         <= (hsync == 1'b1) ? hConvReg[10:2] : 
                                        (stateReg == INIT) ? pixelPerLineReg - {1'b0, burstSizeNext} : pixelPerLineReg;
    end

endmodule