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

    reg en0  = 0, en1 = 0, en2 = 0, en3 = 0;


    counter #(.WIDTH(32)) counter0 (
        .clock(clock),
        .reset(reset || stableB[8]),
        .enable(en0),
        .direction(1'b1),
        .counterValue(counterValue0)
    );

    counter #(.WIDTH(32)) counter1 (
        .clock(clock),
        .reset(reset || stableB[9]),
        .enable(stall && en1),
        .direction(1'b1),
        .counterValue(counterValue1)
    );

    counter #(.WIDTH(32)) counter2 (
        .clock(clock),
        .reset(reset || stableB[10]),
        .enable(busIdle && en2),
        .direction(1'b1),
        .counterValue(counterValue2)
    );

    counter #(.WIDTH(32)) counter3 (
        .clock(clock),
        .reset(reset || stableB[11]),
        .enable(en3),
        .direction(1'b1),
        .counterValue(counterValue3)
    );

    assign result = (cIn != customId || start == 1'b0) ? 32'b0: (valueA[1:0] == 2'd0) ? counterValue0 : (valueA[1:0] == 2'd1) ? counterValue1 : (valueA[1:0] == 2'd2) ? counterValue2 : counterValue3;

    assign done = (cIn != customId || start == 1'b0) ? 1'b0 : 1'b1;

    always @(posedge clock) begin
        if(reset) begin
            en0 <= 0; en1 <= 0; en2 <= 0; en3 <= 0;
        end else begin
            if(cIn == customId && start == 1'b1) begin
                en0 <= (valueB[4] == 1) ? 0 : (valueB[0] == 1) : 1 : en0;
                en1 <= (valueB[5] == 1) ? 0 : (valueB[1] == 1) : 1 : en1;
                en0 <= (valueB[6] == 1) ? 0 : (valueB[2] == 1) : 1 : en2;
                en0 <= (valueB[7] == 1) ? 0 : (valueB[3] == 1) : 1 : en3;
            end
        end
    end

endmodule