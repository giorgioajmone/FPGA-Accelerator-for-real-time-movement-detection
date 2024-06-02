module dualPortRam #(parameter nrOfEntries = 512, parameter entryLength = 32) ( 
  input wire [$clog2(nrOfEntries)-1:0]  addressIn, addressOut,
  input wire clockA, clockB, writeEnable,
  input wire [entryLength-1:0] dataIn,
  output reg [entryLength-1:0] dataOut
);

  reg [entryLength-1:0] memory [nrOfEntries-1:0];

  always @(posedge clockA) begin
    if (writeEnable) memory[addressIn] <= dataIn;
  end
  
  always @(posedge clockB) dataOut <= memory[addressOut];

endmodule
