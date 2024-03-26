// Giorgio Ajmone 368146, Alessandro Cardinale 368411`


module rgb565grayscaleIse_tb;

    // Define the input signals as reg
    reg start, clock;
    reg[31:0] valueA, valueB;
    reg[7:0] cIn;

    // Define the output signals as wires
    wire        done;
    wire[31:0]  result;

    rgb565grayscaleIse #(.customId(8'hC)) dut
        (
        .start(start),
        .iseId(cIn),
        .valueA(valueA),
        .valueB(valueB),
        .done(done),
        .result(result)
        );

    // Set the rst to 1. keep the rst to 1 for 4 cycles. Set the reset to 0. Start "forever" with the clock
    initial
    begin
        clock = 1'b0;
        repeat (4) #5 clock = ~clock;
        forever #5 clock = ~clock;
    end


    // Instantiate the device under test

    initial
    begin
        
        // Set cIn to the custom instruction
        cIn = 8'hC;

        // Set regB s.t. all the counters are enabled
        valueB = 32'd15;

        // Set regA to read cnt 0
        valueA = 32'd63454;

        // Set the start signal to 1
        start = 1'b1;

        repeat(4) @(negedge clock);

        repeat(3) @(negedge clock);

        // Read cnt 1
        valueA = 32'd11322;

        repeat(5) @(negedge clock);

        // Read cnt 2
        valueA = 32'd9788;

        repeat(2) @(negedge clock);

        repeat(10) @(negedge clock);

        $finish;
    end

    initial
    begin
    $dumpfile("profileCi.vcd");
    $dumpvars(1,dut);
    end

endmodule