

module ramDmaCi_tb;

    // define input/inout tb signals
    reg clock, reset, start;
    reg[31:0] valueA, valueB;
    reg[7:0] CiN;
    wire[31:0] address_data;
    wire[3:0] byte_enables;
    wire[7:0] burst_size;
    wire read_n_write, 
         begin_transaction, end_transaction, data_valid, busy, error;

    // define regs as a workaround of the inout pin
    reg[31:0] address_data_reg;
    reg data_valid_reg;
    reg end_transaction_reg;

    // assign values of the driver regs to the wires that will then be mapped to the inout ports
    assign address_data = address_data_reg;
    assign data_valid = data_valid_reg;
    assign end_transaction = end_transaction_reg;
 
    // define out signals as wires
    output wire done;
    output wire[31:0] result;
    
    // instantiate component
    ramDmaCi #(.customId(8'd27)) dut
        (
            .reset(reset),
            .clock(clock),
            .start(start),
            .valueA(valueA),
            .valueB(valueB),
            .ciN(CiN),
            .address_data(address_data),
            .byte_enables(byte_enables),
            .burst_size(burst_size),
            .read_n_write(read_n_write),
            .begin_transaction(begin_transaction),
            .end_transaction(end_transaction),
            .data_valid(data_valid),
            .busy(busy),
            .error(error),
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

    initial
    begin

        // set CiN to the custom instruction and start to 1
        start = 1;
        CiN = 8'd27;

        // Configurations:
        // set the Block size
        valueA[9] = 1;
        valueA[12:10] = 3'd3;
        valueB[9:0] = 10'd5;
        data_valid_reg = 1'b0;
        address_data_reg = 32'b0;
        end_transaction_reg = 1'b0; 
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

        // start sending data to the dma
        data_valid_reg = 1'b1; // driven by two drives. In DMAController is set to zero.
        address_data_reg = 32'd1;
        repeat(1) @(negedge clock);
        address_data_reg = 32'd2;
        repeat(1) @(negedge clock);
        address_data_reg = 32'd3;
        repeat(1) @(negedge clock);
        address_data_reg = 32'd4;
        repeat(1) @(negedge clock);
        address_data_reg = 32'd5;
        repeat(1) @(posedge clock);
        data_valid_reg = 1'b0;
        end_transaction_reg = 1'b1;
        repeat(1) @(posedge clock);
        end_transaction_reg = 1'b0;
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

