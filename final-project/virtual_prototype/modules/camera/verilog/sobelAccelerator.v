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
        for(i = 0; i < 9; i = i + 1) begin : buffer_instantiation
            sobelBuffer  buffer(.addressIn(address[i]), .addressOut(address[i]), 
                            .clockA(clock), .clockB(~clock), .writeEnable(1'b1), 
                                .dataIn(writeData[i]), .dataOut(readData[i]));
        end
    endgenerate  
    
    wire firstTriplet = count3pixels[2] & count3pixels[1] & count3pixels[0];


    wire[7:0] s_writeAddress [0:8];

    assign s_writeAddress[0] = addressReg[0] + (pixelCount[0] & RowCount[0] & firstTriplet);
    assign s_writeAddress[1] = addressReg[1] + (pixelCount[1] & RowCount[0] & firstTriplet);
    assign s_writeAddress[2] = addressReg[2] + (pixelCount[2] & RowCount[0] & firstTriplet);
    assign s_writeAddress[3] = addressReg[3] + (pixelCount[0] & RowCount[1] & firstTriplet);
    assign s_writeAddress[4] = addressReg[4] + (pixelCount[1] & RowCount[1] & firstTriplet);
    assign s_writeAddress[5] = addressReg[5] + (pixelCount[2] & RowCount[1] & firstTriplet);
    assign s_writeAddress[6] = addressReg[6] + (pixelCount[0] & RowCount[2] & firstTriplet);
    assign s_writeAddress[7] = addressReg[7] + (pixelCount[1] & RowCount[2] & firstTriplet);
    assign s_writeAddress[8] = addressReg[8] + (pixelCount[2] & RowCount[2] & firstTriplet);

    always @(posedge clock) begin
        addressReg[0] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[0];
        addressReg[1] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[1];
        addressReg[2] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[2];
        addressReg[3] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[3];
        addressReg[4] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[4];
        addressReg[5] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[5];
        addressReg[6] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[6];
        addressReg[7] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[7];
        addressReg[8] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[8];
    end      

    reg[5:0] count3pixels;      // put six bits to take into account the row

    always @(posedge clock) begin
        if(reset) begin
            count3pixels <= 6'b000000;
        end else begin
            if(hsync) begin
                count3pixels[2:0] <= 3'b000;       // reset count3pixels at each line
            end else if(~hsync && RowCount != RST_STATE_R) begin
                count3pixels[2:0] <= {count3pixels[1:0], 1'b1};  // values of count3pixels: 001, 011, 111 until the new line
                count3pixels[5:3] <= count3pixels[5:3] | RowCount;
            end else begin
                count3pixels <= count3pixels;
            end
        end
    end

    reg[15:0] filteredData[0:8];

    assign writeData[0] = readData[0] & {16{~RowCount[0] & ~pixelCount[0]}} + filteredData[0];
    assign writeData[1] = readData[1] & {16{~RowCount[0] & ~pixelCount[1]}} + filteredData[1];
    assign writeData[2] = readData[2] & {16{~RowCount[0] & ~pixelCount[2]}} + filteredData[2];
    assign writeData[3] = readData[3] & {16{~RowCount[1] & ~pixelCount[0]}} + filteredData[3];
    assign writeData[4] = readData[4] & {16{~RowCount[1] & ~pixelCount[1]}} + filteredData[4];
    assign writeData[5] = readData[5] & {16{~RowCount[1] & ~pixelCount[2]}} + filteredData[5];
    assign writeData[6] = readData[6] & {16{~RowCount[2] & ~pixelCount[0]}} + filteredData[6];
    assign writeData[7] = readData[7] & {16{~RowCount[2] & ~pixelCount[1]}} + filteredData[7];
    assign writeData[8] = readData[8] & {16{~RowCount[2] & ~pixelCount[2]}} + filteredData[8];

    wire[15:0] resultx1  = camData;
    wire[15:0] resultx2  = camData << 1;
    wire[15:0] resultx_1 = ~camData + 1;
    wire[15:0] resultx_2 = ~(camData << 1) + 1; 

    // MEM 0
    always @* begin
        if((RowCount[0] & pixelCount[0]) | RowCount[2] & pixelCount[0]) begin
                filteredData[0] = resultx_1;
        end else if((RowCount[0] & pixelCount[2]) | (RowCount[2] & pixelCount[2])) begin
                filteredData[0] = resultx1;
        end else if(RowCount[1] & pixelCount[0]) begin
                filteredData[0] = resultx_2;
        end else if(RowCount[1] & pixelCount[2]) begin
                filteredData[0] = resultx2;
        end else begin
                filteredData[0] = 16'd0;
        end
    end

    // MEM 1
    always @(*) begin
        if((RowCount[0] & pixelCount[1]) | RowCount[2] & pixelCount[1]) begin
                filteredData[1] = resultx_1;
        end else if((RowCount[0] & pixelCount[0]) | (RowCount[2] & pixelCount[0])) begin
                filteredData[1] = resultx1;
        end else if(RowCount[1] & pixelCount[1]) begin
                filteredData[1] = resultx_2;
        end else if(RowCount[1] & pixelCount[0]) begin
                filteredData[1] = resultx2;
        end else begin
                filteredData[1] = 16'd0;
        end        
    end

    // MEM 2
    always @(*) begin
        if((RowCount[0] & pixelCount[2]) | RowCount[2] & pixelCount[2]) begin
                filteredData[2] = resultx_1;
        end else if((RowCount[0] & pixelCount[1]) | (RowCount[2] & pixelCount[1])) begin
                filteredData[2] = resultx1;
        end else if(RowCount[1] & pixelCount[2]) begin
                filteredData[2] = resultx_2;
        end else if(RowCount[1] & pixelCount[1]) begin
                filteredData[2] = resultx2;
        end else begin
                filteredData[1] = 16'd0;
        end        
    end

    // MEM 3
    always @* begin
        if((RowCount[1] & pixelCount[0]) | RowCount[0] & pixelCount[0]) begin
                filteredData[3] = resultx_1;
        end else if((RowCount[1] & pixelCount[2]) | (RowCount[0] & pixelCount[2])) begin
                filteredData[3] = resultx1;
        end else if(RowCount[2] & pixelCount[0]) begin
                filteredData[3] = resultx_2;
        end else if(RowCount[2] & pixelCount[2]) begin
                filteredData[3] = resultx2;
        end else begin
                filteredData[3] = 16'd0;
        end
    end

    // MEM 4
    always @(*) begin
        if((RowCount[1] & pixelCount[1]) | RowCount[0] & pixelCount[1]) begin
                filteredData[4] = resultx_1;
        end else if((RowCount[1] & pixelCount[0]) | (RowCount[0] & pixelCount[0])) begin
                filteredData[4] = resultx1;
        end else if(RowCount[2] & pixelCount[1]) begin
                filteredData[4] = resultx_2;
        end else if(RowCount[2] & pixelCount[0]) begin
                filteredData[4] = resultx2;
        end else begin
                filteredData[4] = 16'd0;
        end        
    end

    // MEM 5
    always @(*) begin
        if((RowCount[1] & pixelCount[2]) | RowCount[0] & pixelCount[2]) begin
                filteredData[5] = resultx_1;
        end else if((RowCount[1] & pixelCount[1]) | (RowCount[0] & pixelCount[1])) begin
                filteredData[5] = resultx1;
        end else if(RowCount[2] & pixelCount[2]) begin
                filteredData[5] = resultx_2;
        end else if(RowCount[2] & pixelCount[1]) begin
                filteredData[5] = resultx2;
        end else begin
                filteredData[5] = 16'd0;
        end        
    end

    // MEM 6
    always @* begin
        if((RowCount[2] & pixelCount[0]) | RowCount[1] & pixelCount[0]) begin
                filteredData[6] = resultx_1;
        end else if((RowCount[2] & pixelCount[2]) | (RowCount[1] & pixelCount[2])) begin
                filteredData[6] = resultx1;
        end else if(RowCount[0] & pixelCount[0]) begin
                filteredData[6] = resultx_2;
        end else if(RowCount[0] & pixelCount[2]) begin
                filteredData[6] = resultx2;
        end else begin
                filteredData[6] = 16'd0;
        end
    end

    // MEM 7
    always @(*) begin
        if((RowCount[2] & pixelCount[1]) | RowCount[1] & pixelCount[1]) begin
                filteredData[7] = resultx_1;
        end else if((RowCount[2] & pixelCount[0]) | (RowCount[1] & pixelCount[0])) begin
                filteredData[7] = resultx1;
        end else if(RowCount[0] & pixelCount[1]) begin
                filteredData[7] = resultx_2;
        end else if(RowCount[0] & pixelCount[0]) begin
                filteredData[7] = resultx2;
        end else begin
                filteredData[7] = 16'd0;
        end        
    end

    // MEM 8
    always @(*) begin
        if((RowCount[2] & pixelCount[2]) | RowCount[1] & pixelCount[2]) begin
                filteredData[8] = resultx_1;
        end else if((RowCount[2] & pixelCount[1]) | (RowCount[1] & pixelCount[1])) begin
                filteredData[8] = resultx1;
        end else if(RowCount[0] & pixelCount[2]) begin
                filteredData[8] = resultx_2;
        end else if(RowCount[0] & pixelCount[1]) begin
                filteredData[8] = resultx2;
        end else begin
                filteredData[8] = 16'd0;
        end        
    end



    // Define the Ring Counters, i.e. state machines of the system
    // Nota: un po' overkill farlo così. Si potrebbe fare un solo always(posedge) con logica dentro. Così però si separano parte seuqenziale e combinatoria e magari si aiuta il costruttore

    // Pixel counter
    localparam RST_STATE_P= 3'd0;
    localparam P0 = 3'b001;
    localparam P1 = 3'b010;
    localparam P2 = 3'b100;

    reg[2:0] pixelCount, nextStateP;

    // Combinational: Compute new state
    always @* begin
        case(pixelCount)
            RST_STATE_P:    nextStateP <= (hsync == 1'b1) ? P0 : RST_STATE_P;
            P0:             nextStateP <= (validCamera == 1'b1)  ? P1 : P0;
            P1:             nextStateP <= (validCamera == 1'b1)  ? P2 : P1; 
            P2:             nextStateP <= (validCamera == 1'b1)  ? P0 : P2;
            default:        nextStateP <= RST_STATE_P;
        endcase
    end

    //Sequential: latch the new state
    always @(posedge clock) begin
        pixelCount <= (reset == 1'b1) ? RST_STATE_P : nextStateP; 
    end

    // Row counter

    localparam RST_STATE_R= 3'd0;
    localparam R0 = 3'b001;
    localparam R1 = 3'b010;
    localparam R2 = 3'b100;

    reg[2:0] RowCount, nextStateR;

    // Combinational: Compute new state
    always @* begin
        case(RowCount)
            RST_STATE_R:    nextStateR <= (hsync == 1'b1) ? R0 : RST_STATE_R;
            R0:             nextStateR <= (hsync == 1'b1) ? R1 : R0;
            R1:             nextStateR <= (hsync == 1'b1) ? R2 : R1;
            R2:             nextStateR <= (hsync == 1'b1) ? R0 : R2;
            default:        nextStateR <= RST_STATE_R;
        endcase
    end

    //Sequential: latch the new state
    always @(posedge clock) begin
        pixelCount <= (reset == 1'b1) ? RST_STATE_R : nextStateR; 
    end

    
    //per salvare quello che è stato completato readData[indexes[0]]
    wire[31:0] s_busPixelWord;

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
        pixelPerLineReg         <= (hsync == 1'b1) ? 8'b0 : //da modificare per mettere counter dei pxel per riga
                                        (stateReg == INIT) ? pixelPerLineReg - {1'b0, burstSizeNext} : pixelPerLineReg;
    end

endmodule