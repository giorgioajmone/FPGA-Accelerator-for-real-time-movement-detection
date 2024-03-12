module profileCi #(parameter[7:0] customId = 8'h00)
    (
        input wire start, clock, reset, stall, busIdle, 
        input wire[31:0] valueA, valueB,
        input wire [7:0] cIn,
        output wire done,
        output wire[31:0] result
    );

    wire [31:0] counterValue0;
    wire [31:0] counterValue1;
    wire [31:0] counterValue2;
    wire [31:0] counterValue3;
    reg  [31:0] stableB;


    counter #(.WIDTH(32)) counter0 (
        .clock(clock),
        .reset(reset || stableB[8]),
        .enable(start && stableB[0]),
        .direction(1'b1),
        .counterValue(counterValue0)
    );

    counter #(.WIDTH(32)) counter1 (
        .clock(clock),
        .reset(reset || stableB[9]),
        .enable(stall && stableB[1]),
        .direction(1'b1),
        .counterValue(counterValue1)
    );

    counter #(.WIDTH(32)) counter2 (
        .clock(clock),
        .reset(reset || stableB[10]),
        .enable(busIdle && stableB[2]),
        .direction(1'b1),
        .counterValue(counterValue2)
    );

    counter #(.WIDTH(32)) counter3 (
        .clock(clock),
        .reset(reset || stableB[11]),
        .enable(start && stableB[3]),
        .direction(1'b1),
        .counterValue(counterValue3)
    );

    assign result = (cIn != customId || start == 1'b0) ? 32'b0: (valueA[1:0] == 2'd0) ? counterValue0 : (valueA[1:0] == 2'd1) ? counterValue1 : (valueA[1:0] == 2'd2) ? counterValue2 : counterValue3;

    assign done = (cIn != customId || start == 1'b0) ? 1'b0 : 1'b1;

    always @(posedge clock) begin

        if(cIn == customId && start == 1'b1) begin
            stableB <= valueB;
        end

    end

endmodule