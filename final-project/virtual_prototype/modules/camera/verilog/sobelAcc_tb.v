`timescale 1ns / 1ps

module sobelAcc_tb;

parameter customId = 8'h27;

// Inputs
reg clock_tb, reset_tb, hsync_tb, vsync_tb;
reg[7:0] camData_tb;

integer i;

initial begin
    $dumpfile("sobellAcc.vcd");
    $dumpvars(0, sobelAcc_tb);
end

// insantiate the dut

sobelAcc #(.customId(customId)) dut(
    .clock(clock_tb),
    .reset(reset_tb),
    .hsync(hsync_tb),
    .vsync(vsync_tb),
    .camData(camData_tb)
);

// Clock generation
always #5 clock_tb = ~clock_tb;

initial begin
    reset_tb = 1;
    clock_tb = 0;
    hsync_tb = 0;
    vsync_tb = 0;

    // Wait to finish reset
    #100;

    @(negedge clock_tb);
    
    reset_tb = 0;
    #50;

    // Start new frame
    vsync_tb = 1;
    #20;
    vsync_tb = 0;
    #50

    // start new line
    hsync_tb = 1;

    camData_tb = 8'd0;
    #10;
    hsync_tb = 0;
    for(i = 1; i < 640; i = i+1) begin
        if(camData_tb < 8'd255) begin
            camData_tb = camData_tb + 8'd1;
        end else begin
            camData_tb = 8'd0;
        end
        #10;
    end

    #100;
    // new line
    hsync_tb = 1;

    camData_tb = 8'd1;
    #10;
    hsync_tb = 0;
    for(i = 1; i < 640; i = i+1) begin
        if(camData_tb < 8'd255) begin
            camData_tb = camData_tb + 8'd1;
        end else begin
            camData_tb = 8'd0;
        end
        #10;
    end

    #100;
    // new line
    hsync_tb = 1;
    camData_tb = 8'd2;
    #10;
    hsync_tb = 0;
    for(i = 1; i < 640; i = i+1) begin
         if(camData_tb < 8'd255) begin
            camData_tb = camData_tb + 8'd1;
        end else begin
            camData_tb = 8'd0;
        end
        #10;
    end

    #100;
    // new line
    hsync_tb = 1;

    camData_tb = 8'd3;
    #10;
    hsync_tb = 0;
    for(i = 1; i < 640; i = i+1) begin
        if(camData_tb < 8'd255) begin
            camData_tb = camData_tb + 8'd1;
        end else begin
            camData_tb = 8'd0;
        end
        #10;
    end

    #10000;

    $finish;



end

endmodule