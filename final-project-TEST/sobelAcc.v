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

    //TO DO : overwrite, transfer start signal, verilog language details 

    reg[7:0] writeAddress [0:8];
    reg[7:0] readAddress [0:8];
    reg writeEnable [0:8];
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
    
    wire firstTriplet = count3pixels[2] & count3pixels[1] & count3pixels[0];


    wire[7:0] s_writeAddress [0:8];

    assign s_writeAddress[0] = writeAddress[0] + (pixelCount[0] & RowCount[0] & firstTriplet);
    assign s_writeAddress[1] = writeAddress[1] + (pixelCount[1] & RowCount[0] & firstTriplet);
    assign s_writeAddress[2] = writeAddress[2] + (pixelCount[2] & RowCount[0] & firstTriplet);
    assign s_writeAddress[3] = writeAddress[3] + (pixelCount[0] & RowCount[1] & firstTriplet);
    assign s_writeAddress[4] = writeAddress[4] + (pixelCount[1] & RowCount[1] & firstTriplet);
    assign s_writeAddress[5] = writeAddress[5] + (pixelCount[2] & RowCount[1] & firstTriplet);
    assign s_writeAddress[6] = writeAddress[6] + (pixelCount[0] & RowCount[2] & firstTriplet);
    assign s_writeAddress[7] = writeAddress[7] + (pixelCount[1] & RowCount[2] & firstTriplet);
    assign s_writeAddress[8] = writeAddress[8] + (pixelCount[2] & RowCount[2] & firstTriplet);

    always @(posedge clock) begin
            writeAddress[0] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[0];
            writeAddress[1] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[1];
            writeAddress[2] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[2];
            writeAddress[3] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[3];
            writeAddress[4] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[4];
            writeAddress[5] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[5];
            writeAddress[6] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[6];
            writeAddress[7] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[7];
            writeAddress[8] <= (reset == 1'b1 || hsync == 1'b1) ? 8'd0 : s_writeAddress[8];
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

    always @(posedge clock) begin
        writeEnable[0] = (count3pixels[0] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[0];
        writeEnable[1] = (count3pixels[1] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[1];
        writeEnable[2] = (count3pixels[2] & count3pixels[3]) ? 1'b1 : RowCount[0] & pixelCount[2];
        writeEnable[3] = (count3pixels[0] & count3pixels[4]) ? 1'b1 : RowCount[1] & pixelCount[0];
        writeEnable[4] = (count3pixels[1] & count3pixels[4]) ? 1'b1 : RowCount[1] & pixelCount[1];
        writeEnable[5] = (count3pixels[2] & count3pixels[4]) ? 1'b1 : RowCount[1] & pixelCount[2];
        writeEnable[6] = (count3pixels[0] & count3pixels[5]) ? 1'b1 : RowCount[2] & pixelCount[0];
        writeEnable[7] = (count3pixels[1] & count3pixels[5]) ? 1'b1 : RowCount[2] & pixelCount[1];
        writeEnable[8] = (count3pixels[2] & count3pixels[5]) ? 1'b1 : RowCount[2] & pixelCount[2];
    end

    // Perform the overwriting: overwrite in every memory, then the writeEnable should manage if the overwriting occurs or not

    wire overwrite = ~RowCount[0];   // overwrite at each new triplet or rows. active low signal

    wire[15:0] filteredData[0:8];

    assign writeData[0] = readData[0] + filteredData[0];
    assign writeData[1] = readData[1] + filteredData[1];    
    assign writeData[2] = readData[2] + filteredData[2];
    assign writeData[3] = readData[3] + filteredData[3];
    assign writeData[4] = readData[4] + filteredData[4];
    assign writeData[5] = readData[5] + filteredData[5];
    assign writeData[6] = readData[6] + filteredData[6];
    assign writeData[7] = readData[7] + filteredData[7];
    assign writeData[8] = readData[8] + filteredData[8];

    // Compute in advance all the possible results and then multiplex them for every memory

    wire[15:0] resultx1  = camData;
    wire[15:0] resultx2  = camData << 1;
    wire[15:0] resultx_1 = ~camData + 1;
    wire[15:0] resultx_2 = ~(camData << 1) + 1; 


    // Chose the filteredData of the Sobel filter according to the Row and Column of the pixel: hard-code the logic to each memory block

    // X filtering

    reg[2:0] filteredData[0:8];  // 3 bits to support the 2's complement

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


endmodule