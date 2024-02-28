`timescale 1ps/1ps

module fifoTestBench;

  reg clock, reset, s_push, s_pop;
  wire s_empty, s_full;
  reg [31:0] s_pushData;
  wire [31:0] s_popData;

  fifo #(.nrOfEntries(32), .bitWidth(32)) dut 
    ( .reset(reset),
      .clock(clock),
      .push(s_push),
      .pop(s_pop),
      .full(s_full),
      .empty(s_empty),
      .pushData(s_pushData),
      .popData(s_popData)
    );
  
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
        s_push = 1'b0;
        s_pop = 1'b0;
        s_pushData = 8'd1;
        @(negedge reset);
        repeat(2) @(negedge clock);
        s_push = 1'b1;
        repeat(31) @(negedge clock) s_pushData = s_pushData + 8'd1;
        s_push = 1'b0;
        s_pop = 1'b1;
        repeat(31) @(negedge clock);
        s_pop = 1'b0;
        $finish;
    end
 
    initial
    begin
      $dumpfile("fifoSignals.vcd");
      $dumpvars(1,dut);
    end

endmodule
