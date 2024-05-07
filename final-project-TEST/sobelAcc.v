module sobelAcc #(parameter [7:0] customId = 8'd0) (
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

    // Instantiate the memories
    
    // Secondo me il for generate così non è sbagliato. Magari il tool li sintetizza come segnali diversi, ma è più veloce da scrivere

    reg[7:0] writeAddress [0:8];
    reg[7:0] readAddress [0:8];
    wire writeEnable [0:8];
    wire [15:0] writeData [0:8];
    wire [15:0] readData [0:8];

    genvar i;
    generate
        for(i = 0; i < 9; i = i + 1) begin : buffer_instantiation
            sobelBuffer  buffer(.addressIn(writeAddress[i]), .addressOut(readAddress[i]), 
                            .clockA(clock), .clockB(~clock), .writeEnable(writeEnable[i]), 
                                .dataIn(writeData[i]), .dataOut(readData[i]));
        end
    endgenerate  

    // Update Write Address of memories

    // Sequential: in theory, a bunch of adders working in parallel

    
    wire firstTriplet = count3pixels[2] & count3pixels[1] & count3pixels[0];    // active low signal


    wire[7:0] s_writeAddress [0:8];

    assign s_writeAddress[0] = writeAddress[0] + (pixelCount[0] & RowCount[0] & firstTriplet);            // only mem0 still updated at the last triplet of pixels
    assign s_writeAddress[1] = writeAddress[1] + (pixelCount[1] & RowCount[0] & ~endLine & firstTriplet);
    assign s_writeAddress[2] = writeAddress[2] + (pixelCount[2] & RowCount[0] & ~endLine & firstTriplet);
    assign s_writeAddress[3] = writeAddress[3] + (pixelCount[0] & RowCount[1] & ~endLine & firstTriplet);
    assign s_writeAddress[4] = writeAddress[4] + (pixelCount[1] & RowCount[1] & ~endLine & firstTriplet);
    assign s_writeAddress[5] = writeAddress[5] + (pixelCount[2] & RowCount[1] & ~endLine & firstTriplet);
    assign s_writeAddress[6] = writeAddress[6] + (pixelCount[0] & RowCount[2] & ~endLine & firstTriplet);
    assign s_writeAddress[7] = writeAddress[7] + (pixelCount[1] & RowCount[2] & ~endLine & firstTriplet);
    assign s_writeAddress[8] = writeAddress[8] + (pixelCount[2] & RowCount[2] & ~endLine & firstTriplet);

    // Latch the results: read and write addresses are always the same (one memory cell = one window)
    always @(posedge clock) begin
        if(reset) begin
            writeAddress[0] <= 8'd0;
            writeAddress[1] <= 8'd0;
            writeAddress[2] <= 8'd0;
            writeAddress[3] <= 8'd0;
            writeAddress[4] <= 8'd0;
            writeAddress[5] <= 8'd0;
            writeAddress[6] <= 8'd0;
            writeAddress[7] <= 8'd0;
            writeAddress[8] <= 8'd0;
        end else begin
            writeAddress[0] <= s_writeAddress[0];
            writeAddress[1] <= s_writeAddress[1];
            writeAddress[2] <= s_writeAddress[2];
            writeAddress[3] <= s_writeAddress[3];
            writeAddress[4] <= s_writeAddress[4];
            writeAddress[5] <= s_writeAddress[5];
            writeAddress[6] <= s_writeAddress[6];
            writeAddress[7] <= s_writeAddress[7];
            writeAddress[8] <= s_writeAddress[8];
        end
    end

    always @(posedge clock) begin
        if(reset) begin
            readAddress[0] <= 8'd0;
            readAddress[1] <= 8'd0;
            readAddress[2] <= 8'd0;
            readAddress[3] <= 8'd0;
            readAddress[4] <= 8'd0;
            readAddress[5] <= 8'd0;
            readAddress[6] <= 8'd0;
            readAddress[7] <= 8'd0;
            readAddress[8] <= 8'd0;
        end else begin
            readAddress[0] <= s_writeAddress[0];
            readAddress[1] <= s_writeAddress[1];
            readAddress[2] <= s_writeAddress[2];
            readAddress[3] <= s_writeAddress[3];
            readAddress[4] <= s_writeAddress[4];
            readAddress[5] <= s_writeAddress[5];
            readAddress[6] <= s_writeAddress[6];
            readAddress[7] <= s_writeAddress[7];
            readAddress[8] <= s_writeAddress[8];
        end
    end    

    // Detect end of line (not very efficient beacause 8 bits counter)

    reg[7:0] tripletsCount;
    
    // endLine gets set when tripletsCount == 8'd212, but reset at the beginning of every line
    wire endLine = (tripletsCount == 8'd212) ? 1'b1 ^ hsync : 1'b0 ^ hsync;     // same as saying !hsync. like this more readable maybe

    // tripletsCount updates when pixelCount[2] == 1 and I have not finished the line
    always @(posedge clock) begin
        if(reset) begin
            tripletsCount <= 8'd0;
        end else begin
            if(pixelCount[2] & (~endLine)) begin
                tripletsCount <= tripletsCount + 1;
            end else if(hsync) begin
                tripletsCount <= 8'd0;
            end else begin
                tripletsCount <= tripletsCount;
            end
        end
    end    

    // Open a memory block by setting his write enable signal: after 3 pixels in a row, all the three mems corresponding to that row will stay open
    // Add an endFrame condition to take into account the last 3 rows (last 2 rows do not write in mems 3-8 anymore)

    reg[7:0] tripletsRowsCount;

    wire endFrame = (tripletsRowsCount == 8'd159) ? 1'b1 ^ vsync : 1'b0 ^ vsync;

    always @(posedge clock) begin
        if(reset) begin
            tripletsRowsCount <= 8'd0;
        end else begin
            if(pixelCount[2] & (~endFrame)) begin
                tripletsRowsCount <= tripletsRowsCount + 1;
            end else if(vsync) begin
                tripletsRowsCount <= 8'd0;
            end else begin
                tripletsRowsCount <= tripletsRowsCount;
            end
        end
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

    // add condition of count3pixels
    assign writeEnable[0] = (count3pixels[0] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[0];                         // only mem0/1/2 updated at the last triplet of rows
    assign writeEnable[1] = (count3pixels[1] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[1];
    assign writeEnable[2] = (count3pixels[2] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[2];
    assign writeEnable[3] = (count3pixels[0] & count3pixels[4]) ? 1'b1 & ~endFrame : RowCount[1] & pixelCount[0] & ~endFrame;
    assign writeEnable[4] = (count3pixels[1] & count3pixels[4]) ? 1'b1 & ~endFrame : RowCount[1] & pixelCount[1] & ~endFrame;
    assign writeEnable[5] = (count3pixels[2] & count3pixels[4]) ? 1'b1 & ~endFrame : RowCount[1] & pixelCount[2] & ~endFrame;
    assign writeEnable[6] = (count3pixels[0] & count3pixels[5]) ? 1'b1 & ~endFrame : RowCount[2] & pixelCount[0] & ~endFrame;
    assign writeEnable[7] = (count3pixels[1] & count3pixels[5]) ? 1'b1 & ~endFrame : RowCount[2] & pixelCount[1] & ~endFrame;
    assign writeEnable[8] = (count3pixels[2] & count3pixels[5]) ? 1'b1 & ~endFrame : RowCount[2] & pixelCount[2] & ~endFrame;

    // Perform the overwriting: overwrite in every memory, then the writeEnable should manage if the overwriting occurs or not

    assign writeData[0] = readData[0] + camData * coefficient[0];
    assign writeData[1] = readData[1] + camData * coefficient[1];    
    assign writeData[2] = readData[2] + camData * coefficient[2];
    assign writeData[3] = readData[3] + camData * coefficient[3];
    assign writeData[4] = readData[4] + camData * coefficient[4];
    assign writeData[5] = readData[5] + camData * coefficient[5];
    assign writeData[6] = readData[6] + camData * coefficient[6];
    assign writeData[7] = readData[7] + camData * coefficient[7];
    assign writeData[8] = readData[8] + camData * coefficient[8];


    // Chose the coefficient of the Sobel filter according to the Row and Column of the pixel: hard-code the logic to each memory block

    // X filtering

    reg[2:0] coefficient[0:8];  // 3 bits to support the 2's complement

    // MEM 0
    always @* begin
        if((RowCount[0] & pixelCount[0]) | RowCount[2] & pixelCount[0]) begin
                coefficient[0] = -1;
        end else if((RowCount[0] & pixelCount[2]) | (RowCount[2] & pixelCount[2])) begin
                coefficient[0] = 3'd1;
        end else if(RowCount[1] & pixelCount[0]) begin
                coefficient[0] = -2;
        end else if(RowCount[1] & pixelCount[2]) begin
                coefficient[0] = 3'd2;
        end else begin
                coefficient[0] = 3'd0;
        end
    end

    // MEM 1
    always @(*) begin
        if((RowCount[0] & pixelCount[1]) | RowCount[2] & pixelCount[1]) begin
                coefficient[1] = -1;
        end else if((RowCount[0] & pixelCount[0]) | (RowCount[2] & pixelCount[0])) begin
                coefficient[1] = 3'd1;
        end else if(RowCount[1] & pixelCount[1]) begin
                coefficient[1] = -2;
        end else if(RowCount[1] & pixelCount[0]) begin
                coefficient[1] = 3'd2;
        end else begin
                coefficient[1] = 3'd0;
        end        
    end

    // MEM 2
    always @(*) begin
        if((RowCount[0] & pixelCount[2]) | RowCount[2] & pixelCount[2]) begin
                coefficient[2] = -1;
        end else if((RowCount[0] & pixelCount[1]) | (RowCount[2] & pixelCount[1])) begin
                coefficient[2] = 3'd1;
        end else if(RowCount[1] & pixelCount[2]) begin
                coefficient[2] = -2;
        end else if(RowCount[1] & pixelCount[1]) begin
                coefficient[2] = 3'd2;
        end else begin
                coefficient[1] = 3'd0;
        end        
    end

    // MEM 3
    always @* begin
        if((RowCount[1] & pixelCount[0]) | RowCount[0] & pixelCount[0]) begin
                coefficient[3] = -1;
        end else if((RowCount[1] & pixelCount[2]) | (RowCount[0] & pixelCount[2])) begin
                coefficient[3] = 3'd1;
        end else if(RowCount[2] & pixelCount[0]) begin
                coefficient[3] = -2;
        end else if(RowCount[2] & pixelCount[2]) begin
                coefficient[3] = 3'd2;
        end else begin
                coefficient[3] = 3'd0;
        end
    end

    // MEM 4
    always @(*) begin
        if((RowCount[1] & pixelCount[1]) | RowCount[0] & pixelCount[1]) begin
                coefficient[4] = -1;
        end else if((RowCount[1] & pixelCount[0]) | (RowCount[0] & pixelCount[0])) begin
                coefficient[4] = 3'd1;
        end else if(RowCount[2] & pixelCount[1]) begin
                coefficient[4] = -2;
        end else if(RowCount[2] & pixelCount[0]) begin
                coefficient[4] = 3'd2;
        end else begin
                coefficient[4] = 3'd0;
        end        
    end

    // MEM 5
    always @(*) begin
        if((RowCount[1] & pixelCount[2]) | RowCount[0] & pixelCount[2]) begin
                coefficient[5] = -1;
        end else if((RowCount[1] & pixelCount[1]) | (RowCount[0] & pixelCount[1])) begin
                coefficient[5] = 3'd1;
        end else if(RowCount[2] & pixelCount[2]) begin
                coefficient[5] = -2;
        end else if(RowCount[2] & pixelCount[1]) begin
                coefficient[5] = 3'd2;
        end else begin
                coefficient[5] = 3'd0;
        end        
    end

    // MEM 6
    always @* begin
        if((RowCount[2] & pixelCount[0]) | RowCount[1] & pixelCount[0]) begin
                coefficient[6] = -1;
        end else if((RowCount[2] & pixelCount[2]) | (RowCount[1] & pixelCount[2])) begin
                coefficient[6] = 3'd1;
        end else if(RowCount[0] & pixelCount[0]) begin
                coefficient[6] = -2;
        end else if(RowCount[0] & pixelCount[2]) begin
                coefficient[6] = 3'd2;
        end else begin
                coefficient[6] = 3'd0;
        end
    end

    // MEM 7
    always @(*) begin
        if((RowCount[2] & pixelCount[1]) | RowCount[1] & pixelCount[1]) begin
                coefficient[7] = -1;
        end else if((RowCount[2] & pixelCount[0]) | (RowCount[1] & pixelCount[0])) begin
                coefficient[7] = 3'd1;
        end else if(RowCount[0] & pixelCount[1]) begin
                coefficient[7] = -2;
        end else if(RowCount[0] & pixelCount[0]) begin
                coefficient[7] = 3'd2;
        end else begin
                coefficient[7] = 3'd0;
        end        
    end

    // MEM 8
    always @(*) begin
        if((RowCount[2] & pixelCount[2]) | RowCount[1] & pixelCount[2]) begin
                coefficient[8] = -1;
        end else if((RowCount[2] & pixelCount[1]) | (RowCount[1] & pixelCount[1])) begin
                coefficient[8] = 3'd1;
        end else if(RowCount[0] & pixelCount[2]) begin
                coefficient[8] = -2;
        end else if(RowCount[0] & pixelCount[1]) begin
                coefficient[8] = 3'd2;
        end else begin
                coefficient[8] = 3'd0;
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
            P0:             nextStateP <= P1;
            P1:             nextStateP <= P2;
            P2:             nextStateP <= P0;
            default:        nextStateP <= RST_STATE_P;
        endcase
    end

    //Sequential: latch the new state
    always @(posedge clock) begin
        if(reset) begin
            pixelCount <= RST_STATE_P;
        end else begin
            pixelCount <= nextStateP;
        end
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
        if(reset) begin
            RowCount <= RST_STATE_R;
        end else begin
            RowCount <= nextStateR;
        end
    end


endmodule