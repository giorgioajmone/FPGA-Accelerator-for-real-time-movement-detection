`timescale 1ns / 1ps

module dma_controller_tb;

// Parameters
parameter customIdCPU = 8'hfd;
parameter customIdDMA = 8'hfe;

// Inputs
reg start;
reg clock;
reg reset;
reg [31:0] valueA;
reg [31:0] valueB;
reg [7:0] ciN;
reg transactionGranted;
reg endTransactionIn;
reg dataValidIn;
reg busErrorIn;
reg busyBitIn;
reg beginTransactionIn;
reg [31:0] addressDataIn;
integer i,j,burstsizeout;


// Outputs
wire done;
wire [31:0] result;
wire requestTransaction;
wire beginTransactionOut;
wire [7:0] burstSizeOut;
wire dataValidOut;
wire [31:0] addressDataOut;


wire dataValid;
wire [31:0] addressData;

assign dataValid = dataValidIn| dataValidOut;
assign addressData = addressDataIn | addressDataOut;



initial begin
    $dumpfile("ramDmaCi.vcd");
    $dumpvars(0, dma_controller_tb);
end

// Instantiate the Unit Under Test (UUT)
ramDmaCi #(
    //.customIdCPU(customIdCPU),
    .customId(customIdDMA)
) uut (
    .start(start),
    .clock(clock),
    .reset(reset),
    .valueA(valueA),
    .valueB(valueB),
    .ciN(ciN),
    .grantRequest(transactionGranted),
    .end_transaction_in(endTransactionIn),
    .data_valid_in(dataValid),
    .error_in(busErrorIn),
    .busy_in(busyBitIn),
    .address_data_in(addressData),
    .data_valid_out(dataValidOut),
    .done(done),
    .result(result),
    .busRequest(requestTransaction),
    .begin_transaction_out(beginTransactionOut),
    .burst_size_out(burstSizeOut),
    .address_data_out(addressDataOut)
);

// Clock generation
always #5 clock = ~clock;

initial begin
    // Initialize Inputs
    start = 0;
    clock = 0;
    reset = 1;
    valueA = 0;
    valueB = 0;
    ciN = 0;
    transactionGranted = 0;
    endTransactionIn = 0;
    dataValidIn = 0;
    busErrorIn = 0;
    busyBitIn = 0;
    beginTransactionIn = 0;
    addressDataIn = 0;
    transactionGranted = 1'b1;
    // Wait 100 ns for global reset to finish
    #100;
    @(negedge clock);
    //initialize memory
    reset = 0;
    start=1;
    ciN=8'hfe;
    for(i = 0; i < 128; i = i + 1) begin
        if(i == 0) begin 
            valueA = 32'd512;
            valueB = 32'b0;
        end else begin
            valueA = i*32'd1 | 32'd512;
            valueB = i*32'd1;
        end
        #10; 
    end
    start=1;
    ciN=0;
    #10;
    // test configuration writes and reads
    start=1;
    ciN=8'hfe;
    valueA=32'h00000600; // write 89 on busstart address
    valueB=32'd89;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h00000400; //read busstart address
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50;
    start=1;
    ciN=8'hfe;
    valueA=32'h00000a00; // write 46 on memory start address 
    valueB=32'd0;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h00000800; //read memory start address
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50;
    start=1;
    ciN=8'hfe;
    valueA=32'h00000e00; // write 64 on block siye
    valueB=32'd64;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h00000c00; //read block size
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50;
    start=1;
    ciN=8'hfe;
    valueA=32'h00001200; // write 7 on burst size
    valueB=32'd7;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h00001000; //read burst size
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h00001400; //read status register
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50;
    start=1;
    ciN=8'hfe;
    valueA=32'h00001600; //read status register
    valueB = 32'd2;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #140;
    busyBitIn=1;
    #100;
    busyBitIn=0;
    #10000


    $finish;


end
endmodule