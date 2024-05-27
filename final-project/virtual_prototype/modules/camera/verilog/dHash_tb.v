`timescale 1ns / 1ps

module dHash_tb;

parameter customId = 8'h27;

// Inputs
reg clock_tb, camClock_tb, reset_tb, edgeHsync_tb, edgeVsync_tb, validCamera_tb, vsync_tb, hsync_tb;
reg[7:0] camData_tb, ciN_tb;
reg[31:0] ciValueA_tb, ciValueB_tb;

reg vsyncClk, hsyncClk, validClk;
reg[7:0] grayClk;

integer i, frame, line, k;

initial begin
    $dumpfile("dHash.vcd");
    $dumpvars(0, dHash_tb);
end

// insantiate the dut

dHash #(.customId(8'd27)) dut (
    .clock(clock_tb),
    .camClock(clock_tb), 
    .reset(reset_tb), 
    .hsync(hsyncClk), 
    .vsync(vsyncClk), 
    .ciStart(1'b1), 
    .validCamera(validClk),
    .ciN(ciN_tb), 
    .camData(grayClk),
    
    .ciValueA(ciValueA_tb), 
    .ciValueB(ciValueB_tb)
);

always @(posedge clock_tb) begin
    vsyncClk <= (reset_tb == 1'b1) ? 1'b0 : edgeVsync_tb;
    hsyncClk <= (reset_tb == 1'b1) ? 1'b0 : edgeHsync_tb;
    grayClk <= (reset_tb == 1'b1) ? 8'b0 : camData_tb;
    validClk <= (reset_tb == 1'b1) ? 1'b0 : validCamera_tb;
end

// Clock generation
always #5 clock_tb = ~clock_tb;
always #15 camClock_tb = ~camClock_tb;

initial begin
    reset_tb = 1;
    clock_tb = 0;
    camClock_tb = 0;
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
    //set transfer
    ciN_tb = 8'h27;
    ciValueA_tb = 13'b1011000000000;
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

    if(frame == 2) begin
        ciN_tb = 8'h27;
        ciValueA_tb = 13'b1011000000000;
        #50;
        ciN_tb = 8'b0;
    end

    for(line = 0; line < 10; line = line + 1) begin

    // 8================================== LINE ======================================D

    hsync_tb = 1;


    for(i = 0; i < 640; i = i+1) begin
        
        validCamera_tb = 1;

        camData_tb = i*8'd1;
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

    #100;

    // 8============================================================= FRAME ======================================D--
    for(k = 0; k<4; k = k+1) begin
        ciN_tb = 8'h27;
        ciValueA_tb = 32'd1 * k;
        #50;
        ciN_tb = 8'h0;
        #20;
    end 

    #200;

    end

    
    #10000;

    $finish;



end

endmodule