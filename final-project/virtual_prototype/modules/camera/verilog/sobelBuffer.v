module sobelBuffer (input wire [7:0]  addressIn, addressOut,
                    input wire  clockA, clockB, writeEnable,
                    input wire [15:0] dataIn,
                    output reg [15:0] dataOut);

  reg [15:0] memory [255:0];
  
  always @(posedge clock1)
  begin
    if (writeEnable) memory[addressIn] <= dataIn;
  end
  
  always @(posedge clock2) dataOut <= memory[addressOut];

endmodule