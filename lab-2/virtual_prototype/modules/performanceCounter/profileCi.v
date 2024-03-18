
// Giorgio Ajmone 368146, Alessandro Cardinale 368411

module profileCi #(parameter[7:0] customId = 8'h00)
    (
        input wire start, clock, reset, stall, busIdle, 
        input wire[31:0] valueA, valueB,
        input wire [7:0] cIn,
        output wire done,
        output wire[31:0] result
    );

    wire is_valid;

    wire [31:0] counterValue0;
    wire [31:0] counterValue1;
    wire [31:0] counterValue2;
    wire [31:0] counterValue3;

    reg en0  = 1'b0, en1 = 1'b0, en2 = 1'b0, en3 = 1'b0;


    counter #(.WIDTH(32)) counter0 (
        .clock(clock),
        .reset(reset || (valueB[8] && is_valid)),
        .enable(en0),
        .direction(1'b1),
        .counterValue(counterValue0)
    );

    counter #(.WIDTH(32)) counter1 (
        .clock(clock),
        .reset(reset || (valueB[9] && is_valid)),
        .enable(stall && en1),
        .direction(1'b1),
        .counterValue(counterValue1)
    );

    counter #(.WIDTH(32)) counter2 (
        .clock(clock),
        .reset(reset || (valueB[10] && is_valid)),
        .enable(busIdle && en2),
        .direction(1'b1),
        .counterValue(counterValue2)
    );

    counter #(.WIDTH(32)) counter3 (
        .clock(clock),
        .reset(reset || (valueB[11] && is_valid)),
        .enable(en3),
        .direction(1'b1),
        .counterValue(counterValue3)
    );

    
    assign result = (is_valid == 1'b1) ? ((valueA[1:0] == 2'd0) ? counterValue0 : (valueA[1:0] == 2'd1) ? counterValue1 : (valueA[1:0] == 2'd2) ? counterValue2 : counterValue3) : 32'b0;

    assign done = (is_valid == 1'b1) ? 1'b1 : 1'b0;

    assign is_valid = (cIn == customId && start == 1'b1);

    always @(posedge clock) begin
        if(reset) begin
            en0 <= 1'b0; en1 <= 1'b0; en2 <= 1'b0; en3 <= 1'b0;
        end else begin
            if(cIn == customId && start == 1'b1) begin
                en0 <= (valueB[4] == 1'b1) ? 1'b0 : (valueB[0] == 1'b1) ? 1'b1 : en0;
                en1 <= (valueB[5] == 1'b1) ? 1'b0 : (valueB[1] == 1'b1) ? 1'b1 : en1;
                en2 <= (valueB[6] == 1'b1) ? 1'b0 : (valueB[2] == 1'b1) ? 1'b1 : en2;
                en3 <= (valueB[7] == 1'b1) ? 1'b0 : (valueB[3] == 1'b1) ? 1'b1 : en3;
            end
        end
    end

endmodule