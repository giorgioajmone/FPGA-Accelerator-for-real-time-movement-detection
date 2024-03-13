`timescale 1ps/1ps

module profileCi_tb;

    // Define the input signals as reg
    reg clock, reset, stall, busIdle, start;
    reg[31:0] valueA, valueB;
    reg[7:0] cIn;

    // Define the output signals as wires
    wire        done;
    wire[31:0]  result;

    profileCi #(.customId(8'd62)) dut
        (.reset(reset),
        .clock(clock),
        .stall(stall),
        .busIdle(busIdle),
        .start(start),
        .cIn(cIn),
        .valueA(valueA),
        .valueB(valueB),
        .done(done),
        .result(result)
        );

    // Set the rst to 1. keep the rst to 1 for 4 cycles. Set the reset to 0. Start "forever" with the clock
    initial
    begin
        reset = 1'b1;
        clock = 1'b0;
        repeat (4) #5 clock = ~clock;
        reset = 1'b0;
        forever #5 clock = ~clock;
    end


    // Instantiate the device under test

    initial
    begin

        busIdle = 1'b0;
        stall = 1'b0;

        
        // Set cIn to the custom instruction
        cIn = 8'd62;

        // Set regB s.t. all the counters are enabled
        valueB = 32'd15;

        // Set regA to read cnt 0
        valueA = 32'd0;

        // Set the start signal to 1
        start = 1'b1;

        @(negedge reset);
        repeat(4) @(negedge clock);

        busIdle = 1'b1;

        repeat(3) @(negedge clock);

        cIn = 8'd0;

        stall = 1'b1;

        // Read cnt 1
        valueA = 32'd1;

        repeat(5) @(negedge clock);

        // Read cnt 2
        valueA = 32'd0;

        valueB = 32'd240;

        cIn = 8'd62;


        repeat(2) @(negedge clock);

        // Set Cin to another instruction
        cIn = 8'd8;

        repeat(10) @(negedge clock);

        $finish;
    end

    initial
    begin
    $dumpfile("profileCi.vcd");
    $dumpvars(1,dut);
    end

endmodule