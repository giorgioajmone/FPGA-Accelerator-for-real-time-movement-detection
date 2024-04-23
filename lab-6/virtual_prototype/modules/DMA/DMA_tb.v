module DMA_tb;
    reg clock, reset;
    // Ci interface for DMA
    reg [7:0]   ciN;
    reg [31:0]  ciValueA;
    reg [31:0]  ciValueB;
    reg         ciStart;
    wire        ciDone;
    wire [31:0] ciResult;

    // Bus Interface
    wire        requestBus;
    reg         busGrant;
    reg         busErrorIn;
    reg         busyIn;

    wire        beginTransactionOut;
    wire        endTransactionOut;
    reg         endTransactionIn;
    reg         dataValidIn;
    wire        dataValidOut;
    wire        readNotWriteOut;
    wire [3:0]  byteEnablesOut;
    wire [7:0]  burstSizeOut;
    reg [31:0]  addressDataIn;
    wire [31:0] addressDataOut;

    ramDmaCi #(.customId(8'h69)) DMA_inst 
        (
        .start(ciStart),
        .clock(clock),
        .reset(reset),
        .valueA(ciValueA),
        .valueB(ciValueB),
        .ciN(ciN),
        .grantRequest(busGrant),
        .end_transaction_in(endTransactionIn),
        .data_valid_in(dataValidIn),
        .error_in(busErrorIn),
        .busy_in(busyIn),
        .address_data_in(addressDataIn),
        .data_valid_out(dataValidOut),
        .done(ciDone),
        .result(ciResult),
        .busRequest(requestBus),
        .begin_transaction_out(beginTransactionOut),
        .burst_size_out(burstSizeOut),
        .address_data_out(addressDataOut)
        );

    always #5 clock = ~clock;

    initial begin

        $dumpfile("DMA.vcd");
        $dumpvars(0, DMA_tb);

        clock = 0;
        reset = 1;

        ciN = 0;
        ciValueA = 0;
        ciValueB = 0;
        ciStart = 0;
        busGrant = 0;
        busErrorIn = 0;
        busyIn = 0;
        endTransactionIn = 0;
        dataValidIn = 0;
        addressDataIn = 0;
    end

    initial begin
        #20;
        reset = 0;

        // Testing mem2K in isolation
        #10;
        ciN = 8'h69;
        ciValueA = 5 | (1 << 9);
        ciValueB = 20;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 16 | (1 << 9);
        ciValueB = 13;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #40;
        ciN = 8'h69;
        ciValueA = 5 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #100;

        // Testing Bus to mem2K DMA
        // Bus Address
        ciN = 8'h69;
        ciValueA = (1 << 10) | (1 << 9);
        ciValueB = 8386520;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        //mem2K address
        #10;
        ciValueA = (2 << 10) | (1 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Block Size
        #10;
        ciValueA = (3 << 10) | (1 << 9);
        ciValueB = 16;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Burst Size
        #10;
        ciValueA = (4 << 10) | (1 << 9);
        ciValueB = 15;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // CSR
        #10;
        ciValueA = (5 << 10) | (1 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Grant DMA bus access
        #40;
        busGrant = 1;
        #10;
        busGrant = 0;

        // Receive Data from the Bus
        #50;
        dataValidIn = 1;
        addressDataIn = 2;
        #10;
        dataValidIn = 1;
        addressDataIn = 4;
        #10;
        dataValidIn = 1;
        addressDataIn = 6;
        #10;
        dataValidIn = 1;
        addressDataIn = 8;
        #10;
        dataValidIn = 1;
        addressDataIn = 10;
        #10;
        dataValidIn = 1;
        addressDataIn = 12;
        #10;
        dataValidIn = 1;
        addressDataIn = 14;
        #10;
        dataValidIn = 1;
        addressDataIn = 16;
        #10;
        dataValidIn = 1;
        addressDataIn = 18;
        #10;
        dataValidIn = 1;
        addressDataIn = 20;
        #10;
        dataValidIn = 1;
        addressDataIn = 22;
        #10;
        dataValidIn = 1;
        addressDataIn = 24;
        #10;
        dataValidIn = 1;
        addressDataIn = 26;
        #10;
        dataValidIn = 1;
        addressDataIn = 28;
        #10;
        dataValidIn = 1;
        addressDataIn = 30;
        #10;
        dataValidIn = 1;
        addressDataIn = 32;

        // End Transaction
        #10;
        dataValidIn = 0;
        endTransactionIn = 1;
        #10;
        endTransactionIn = 0;

        // Checking values in mem2K
        #40;
        ciN = 8'h69;
        ciValueA = 0 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 1 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 2 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 3 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;
        
        #10;
        ciN = 8'h69;
        ciValueA = 4 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 5 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 6 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 7 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 8 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 9 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 10 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 11 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 12 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 13 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 14 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciN = 8'h69;
        ciValueA = 15 | (0 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Reading DMA Registers

        #50;
        ciValueA = (1 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (2 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (3 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (4 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (5 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #100;

        
        // Testing mem2K to Bus DMA
        // Bus Address
        ciN = 8'h69;
        ciValueA = (1 << 10) | (1 << 9);
        ciValueB = 8386520;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        //mem2K address
        #10;
        ciValueA = (2 << 10) | (1 << 9);
        ciValueB = 0;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Block Size
        #10;
        ciValueA = (3 << 10) | (1 << 9);
        ciValueB = 16;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Burst Size
        #10;
        ciValueA = (4 << 10) | (1 << 9);
        ciValueB = 15;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // CSR
        #10;
        ciValueA = (5 << 10) | (1 << 9);
        ciValueB = 2;   // 3 for write and 1 for read
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        // Grant DMA bus access
        #40;
        busGrant = 1;
        #10;
        busGrant = 0;

        // Send Data to the Bus
        #20;
        busyIn = 1;
        #200;
        busyIn = 0;
        #200;

        // Reading DMA Registers

        #50;
        ciValueA = (1 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (2 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (3 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (4 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #10;
        ciValueA = (5 << 10) | (0 << 9);
        ciValueB = 1;
        ciStart = 1;
        #10;
        ciStart = 0;
        ciValueA = 0;
        ciValueB = 0;

        #1000;
        $finish;
    end


endmodule