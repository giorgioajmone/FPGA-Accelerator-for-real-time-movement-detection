module dualPortRam #(parameter nrOfEntries = 512, parameter entryLength = 32)
                       ( input wire [$clog2(nrOfEntries)-1 :0]  address1,
                                                                address2,
                       input wire        clock1,
                                         clock2,
                                         writeEnable,
                       input wire [entryLength-1:0] dataIn1,
                       output reg [entryLength-1:0] dataOut2);

  reg [entryLength-1:0] memory [nrOfEntries-1:0];
  
  always @(posedge clock1)
  begin
    if (writeEnable) memory[address1] <= dataIn1;
  end
  
  always @(posedge clock2) dataOut2 <= memory[address2];

endmodule
