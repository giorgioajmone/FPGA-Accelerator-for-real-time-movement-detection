module comparator #(parameter [7:0] customId = 8'd0 )
                            ( input wire         start,
                             input wire [31:0]  valueA,
                                                valueB,
                             input wire [7:0]   ciN,
                             output wire        done,
                             output wire [31:0] result );

  wire validInstr = (ciN == customId) ? start : 1'b0;
  
  wire[15:0] msbComparison = (valueA[1] == valueB[1]) ? {16{valueA[1]}} : 16'h6000;
  wire[15:0] lsbComparison = (valueA[0] == valueB[0]) ? {16{valueA[0]}} : 16'h6000;

  assign result = (validInstr == 1'b1) ? {msbComparison, lsbComparison} : 32'b0;
  assign done = validInstr;

endmodule