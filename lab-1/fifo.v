module fifo #(
    parameter nrOfEntries = 16,
    parameter bitWidth = 32
    ) (
    input wire clock, reset, push, pop,
    input wire [bitWidth-1:0] pushData,
    output wire full, empty,
    output wire [bitWidth-1:0] popData
    );

    reg [$clog2(nrOfEntries)-1:0] pushAddress = 0;
    reg [$clog2(nrOfEntries)-1:0] popAddress = 0;  

    semiDualPortSSRAM #(.nrOfEntries(nrOfEntries), .readAfterWrite(0), .bitwidth(bitWidth)) ssram
    (
        .clockA(clock),
        .clockB(clock),
        .writeEnable(push),
        .addressA(pushAddress),
        .addressB(popAddress),
        .dataIn(pushData),
        .dataOutB(popData),
        .dataOutA()
    );

    assign empty = (pushAddress == popAddress) ? 1'b1 : 1'b0;
    assign full = ((popAddress-pushAddress == 1) || (popAddress == 0 && pushAddress == nrOfEntries-1)) ? 1'b1 : 1'b0;
    
    always @(posedge clock)
    begin
        if (reset == 1'b1)
            begin
                pushAddress <= 0;
                popAddress <= 0;
            end
        else
            begin
                if(push == 1'b1)
                    begin
                        pushAddress <= (pushAddress == nrOfEntries-1) ? 0 : pushAddress + 1;
                    end
                if(pop == 1'b1)
                    begin
                        popAddress <= (popAddress == nrOfEntries-1) ? 0 : popAddress + 1;
                    end
            end
    end

endmodule