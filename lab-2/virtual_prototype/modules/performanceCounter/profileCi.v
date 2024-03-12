module profileCi #(parameter[7:0] customId = 8'h00)
    (
        input wire start, clock, reset, stall, busIdle, 
        input wire[31:0] valueA, valueB,
        input wire [7:0] cIn,
        output wire done,
        output wire[31:0] result
    );

    counter #(.WIDTH(32)) counter0 (
        .clock(clock),
        .reset(reset || valueB[8]),
        .enable(start && valueB[0]),
        .direction(1'b1),
        .counterValue()
    );

    counter #(.WIDTH(32)) counter1 (
        .clock(clock),
        .reset(reset || valueB[9]),
        .enable(start && valueB[1]),
        .direction(1'b1),
        .counterValue()
    );

    counter #(.WIDTH(32)) counter2 (
        .clock(clock),
        .reset(reset || valueB[10]),
        .enable(start && valueB[2]),
        .direction(1'b1),
        .counterValue()
    );

    counter #(.WIDTH(32)) counter0 (
        .clock(clock),
        .reset(reset || valueB[11]),
        .enable(start && valueB[3]),
        .direction(1'b1),
        .counterValue()
    );

    assign result <= (cIn != customId || start == 1'b0) ? 32'b0: (A[1:0] == 2'd0) ? counterValue0 : (A[1:0] == 2'd1) ? counterValue1 : (A[1:0] == 2'd2) ? counterValue2 : counter3;

    assign done <= (cIn != customId || start == 1'b0) ? 1'b0 : 1'b1;

    


endmodule