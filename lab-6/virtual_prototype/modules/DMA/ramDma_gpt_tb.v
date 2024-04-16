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
    .data_valid_in(dataValidIn),
    .error_in(busErrorIn),
    .busy_in(busyBitIn),
    .address_data_in(addressDataIn),
    .data_valid_out(dataValidOut),
    .done(done),
    .result(result),
    .busRequest(requestTransaction),
    .begin_transaction_out(beginTransactionOut),
    .burst_size_out(burstSizeOut)
);

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
    // Wait 100 ns for global reset to finish
    #105;
    reset = 0;

    //test simple write & simple read operations
    start=1;
    ciN=8'hfe;
    valueA=32'h000002ab; // write 51 on address ab
    valueB=32'd51;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    #50
    start=1;
    ciN=8'hfe;
    valueA=32'h000000ab; //read address ab
    wait(done);
    #10;
    start=0;
    ciN=0;
    valueA=0;
    #50;
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
     //test transfer from bus to ci memory
    start=1;
    ciN=8'hfe;
    valueA=32'h00001600; // write 1 on control register
    valueB=32'd1;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    
    for (i=0; i<8; i=i+1)begin
        #30;
        transactionGranted=1'b1;
        #10;
        transactionGranted=1'b0;
        beginTransactionIn=1'b1;
        burstsizeout=burstSizeOut;
        #10;
        beginTransactionIn=1'b0;
        endTransactionIn=1'b0;
        for (j=0; j<burstsizeout+1; j=j+1)begin
            if(j==3)begin
                dataValidIn=1'b0;
                #40;
                dataValidIn=1'b1;
                addressDataIn=j*10;
            end
            else begin
                #10;
                dataValidIn=1'b1;
                addressDataIn=j*10;
            end
            $display("write performed %d %d", i, j);
        end
        dataValidIn=1'b0;
        endTransactionIn=1'b1;
        #10;
        endTransactionIn=1'b0;
        
    end
    /*
    #10;
    // test transfer from ci memory to bus
    start=1;
    ciN=8'hfe;
    valueA=32'h00001600; // write 2 on control register
    valueB=32'd2;
    #10;
    start=0;
    ciN=0;
    valueA=0;
    valueB=0;
    for (i=0; i<8; i=i+1)begin
        wait(requestTransaction);
        #30;
        transactionGranted=1'b1;
        wait(beginTransactionOut); //wait for dma to be ready to send data
        burstsizeout=burstSizeOut;
        transactionGranted=1'b0;
        for (j=0; j<burstsizeout+1; j=j+1)begin
            if(j==3)begin  // test the busy bit behavior
                busyBitIn=1'b1;
                #40;
                busyBitIn=1'b0;
            end
            wait(dataValidOut);
            $display("read performed %d %d", i, j);
        end
    end
    // End simulation
    #10;
    */
    $finish;
end

// Clock generation
always #5 clock = ~clock;

endmodule