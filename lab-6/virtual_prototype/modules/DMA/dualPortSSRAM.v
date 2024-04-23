module dualPortSSRAM #( parameter bitwidth = 8, parameter nrOfEntries = 512, parameter readAfterWrite = 0 )
( 
    input wire clockA, clockB, writeEnableA, writeEnableB,
    input wire [$clog2(nrOfEntries)-1 : 0] addressA, addressB,
    input wire [bitwidth-1 : 0] dataInA, dataInB,
    output reg [bitwidth-1 : 0] dataOutA, dataOutB
);

    reg [bitwidth-1 : 0] memoryContent [nrOfEntries-1 : 0];

    always @(posedge clockA)
    begin
        dataOutA <= memoryContent[addressA];
        if (writeEnableA == 1'b1) memoryContent[addressA] <= dataInA;
    end
    always @(posedge clockB)
    begin
        dataOutB <= memoryContent[addressB];
        if (writeEnableB == 1'b1) memoryContent[addressB] <= dataInB;
    end

    /*always @(posedge clockA)
    begin   
        if (writeEnableA) 
        begin
            memoryContent[addressA] <= dataInA;
            dataOutA <= dataInA;
        end
        else
        begin
            dataOutA <= memoryContent[addressA];
        end
    end


    always @(negedge clockB)
    begin   
        if (writeEnableB) 
        begin
            memoryContent[addressB] <= dataInB;
            dataOutB <= dataInB;
        end
        else
        begin
            dataOutB <= memoryContent[addressB];
        end
    end*/


endmodule