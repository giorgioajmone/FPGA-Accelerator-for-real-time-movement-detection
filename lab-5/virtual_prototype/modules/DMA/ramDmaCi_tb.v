

module ramDmaCi_tb;

    // define input/inout tb signals
    reg clock, reset, start;
    reg[31:0] valueA, valueB;
    reg[7:0] CiN;
    reg[31:0] address_data_in;
    reg data_valid_in, end_transaction_in;
    reg grantRequest;
 
    // define out signals as wires
    wire done;
    wire[31:0] result;
    wire[31:0] address_data_out;
    wire[3:0]  byte_enables_out;
    wire[7:0]  burst_size_out;
    wire begin_transaction_out, data_valid_out, end_transaction_out,
         read_n_write_out, busy_in, error_in;
    wire busRequest;
    
    // instantiate component
    ramDmaCi #(.customId(8'd27)) dut
        (
            .reset(reset),
            .clock(clock),
            .start(start),
            .valueA(valueA & 32'b1),
            .valueB(valueB),
            .ciN(CiN),
            .address_data_in(address_data_in),  // no need to do the or beacuse, in this simulation, only one slave talks to the dma
            .address_data_out(address_data_out),
            .byte_enables_out(byte_enables_out),
            .burst_size_out(burst_size_out),
            .read_n_write_out(read_n_write_out),
            .begin_transaction_out(begin_transaction_out),
            .end_transaction_in(end_transaction_in),
            .end_transaction_out(end_transaction_out),
            .data_valid_in(data_valid_in),
            .data_valid_out(data_valid_out),
            .busy_in(busy_in),
            .error_in(error_in),
            .done(done),
            .result(result),
            .grantRequest(grantRequest),
            .busRequest(busRequest)
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

    initial
    begin

        // set CiN to the custom instruction and start to 1
        start = 1;
        CiN = 8'd27;
        grantRequest = 1'b1;

        // Configurations:
        // set the Block size
        valueA[9] = 1;
        valueA[12:10] = 3'd3;
        valueB[9:0] = 10'd5;
        data_valid_in = 1'b0;
        address_data_in = 32'b0;
        end_transaction_in = 1'b0; 
        repeat(3) @(negedge clock);

        // set the burst size
        valueA[12:10] = 3'd4;
        valueB[7:0] = 3'd1; // busrtSize = 2;
        repeat(3) @(negedge clock);

        // set the memory base address
        valueA[12:10] = 3'd2;
        valueB[8:0] = 9'b0;
        repeat(3) @(negedge clock);

        // set the bus base address
        valueA[12:10] = 3'd1;
        valueB[31:0] = 32'd0;
        repeat(3) @(negedge clock);

        // set the control reg to initialize a writing into the CiMem
        valueA[12:10] = 3'd5;
        valueB[1:0] = 1'd1;
        repeat(3) @(negedge clock);
        valueA[31:0] = 32'b0;
        valueB[31:0] = 32'b0;
        repeat(1) @(negedge clock);

        // start sending data to the dma
        data_valid_in = 1'b1; // driven by two drives. In DMAController is set to zero.
        address_data_in = 32'd1;
        repeat(1) @(negedge clock);
        address_data_in = 32'd2;
        repeat(1) @(negedge clock);

        data_valid_in = 1'b0;
        end_transaction_in = 1'b1;
        repeat(1) @(negedge clock);
        end_transaction_in = 1'b0;
        repeat(2) @(negedge clock);

        data_valid_in = 1'b1;
        address_data_in = 32'd3;
        repeat(1) @(negedge clock);
        address_data_in = 32'd4;
        repeat(1) @(negedge clock);

        data_valid_in = 1'b0;
        end_transaction_in = 1'b1;
        repeat(1) @(negedge clock);
        end_transaction_in = 1'b0;
        repeat(2) @(negedge clock);

        data_valid_in = 1'b1;
        address_data_in = 32'd5;
        repeat(1) @(negedge clock);

        data_valid_in = 1'b0;
        end_transaction_in = 1'b1;
        repeat(1) @(negedge clock);
        end_transaction_in = 1'b0;
        repeat(3) @(negedge clock);
        
        // set start to zero
        start = 1'b0;
        repeat(3) @(negedge clock);
        $finish;

    end

initial 
begin
    $dumpfile("ramDmaCi.vcd");
    $dumpvars(0, dut);
end
endmodule

