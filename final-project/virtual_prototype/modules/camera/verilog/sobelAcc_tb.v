`timescale 1ns / 1ps

module sobelAcc_tb;

parameter customId = 8'h27;

// Inputs
reg clock_tb, reset_tb, edgeHsync_tb, edgeVsync_tb, validCamera_tb, vsync_tb, hsync_tb;
reg[7:0] camData_tb, ciN_tb;
reg[31:0] ciValueA_tb, ciValueB_tb;

reg vsyncClk, hsyncClk, validClk;
reg[7:0] grayClk;

integer i, frame, line;

initial begin
    $dumpfile("sobellAcc.vcd");
    $dumpvars(0, sobelAcc_tb);
end

// insantiate the dut

sobelAccelerator #(.customId(8'h27)) sobelino (
    .clock(clock_tb), 
    .camClock(clock_tb), 
    .reset(reset_tb), 
    .hsync(hsyncClk), 
    .vsync(vsyncClk), 
    .validCamera(validClk),
    .camData(grayClk),
    .ciN(ciN_tb),
    .ciValueA(ciValueA_tb),
    .ciValueB(ciValueB_tb),
    .ciStart(1'b1)
);

always @(posedge clock_tb) begin
    vsyncClk <= (reset_tb == 1'b1) ? 1'b0 : edgeVsync_tb;
    hsyncClk <= (reset_tb == 1'b1) ? 1'b0 : edgeHsync_tb;
    grayClk <= (reset_tb == 1'b1) ? 8'b0 : camData_tb;
    validClk <= (reset_tb == 1'b1) ? 1'b0 : validCamera_tb;
end

// Clock generation
always #5 clock_tb = ~clock_tb;

initial begin
    reset_tb = 1;
    clock_tb = 0;
    hsync_tb = 0;
    vsync_tb = 0;
    edgeHsync_tb = 0;
    edgeVsync_tb = 0;
    validCamera_tb = 0;
    camData_tb = 8'd0;
    ciN_tb = 8'b0;
    ciValueA_tb = 32'b0;
    ciValueB_tb = 32'b0;
    // Wait to finish reset
    repeat (100);

    @(negedge clock_tb);
    
    reset_tb = 0;
    #50;

    //set threshold
    ciN_tb = 8'h27;
    ciValueA_tb = 13'b1001000000000;
    ciValueB_tb = 32'd1;
    #50;
    ciN_tb = 8'b0;

    for(frame = 0; frame < 10; frame = frame + 1) begin

    // 8============================================================= FRAME ======================================D
    
    vsync_tb = 1;
    #500;
    
    edgeVsync_tb = 1;
    vsync_tb = 0;

    #10;
    edgeVsync_tb = 0;
    #500;

    for(line = 0; line < 10; line = line + 1) begin

    // 8================================== LINE ======================================D

    hsync_tb = 1;


    for(i = 0; i < 640; i = i+1) begin
        
        validCamera_tb = 1;

        if(camData_tb < 8'd255) begin
            camData_tb = 8'd1; //camData_tb + 8'd1;
        end else begin
            camData_tb = 8'd1; //8'd0;
        end

        #10; 

        validCamera_tb = 0;
        #10;   

    end

    hsync_tb = 0;
    edgeHsync_tb = 1;
    #10;
    edgeHsync_tb = 0;

    #200;

    // 8=============================================================================D--

    end

    #200;

    // 8============================================================= FRAME ======================================D--

    end

    
    #10000;

    $finish;



end

endmodule