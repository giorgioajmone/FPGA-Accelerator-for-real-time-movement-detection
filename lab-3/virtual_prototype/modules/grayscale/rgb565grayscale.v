// Giorgio Ajmone 368146, Alessandro Cardinale 368411

module rgb565grayscaleIse #(parameter[7:0] customId = 8'h00)
    (
        input wire start, 
        input wire[31:0] valueA, valueB,
        input wire [7:0] iseId,
        output wire done,
        output wire[31:0] result
    );

    wire is_valid;

    wire [31:0] gray;

    singlePixel pixelLogic(
        .red(valueA[15:11]),
        .green(valueA[10:5]),
        .blue(valueA[4:0]),
        .result(gray)
    );
   
    assign result = (is_valid == 1'b1) ? (gray) : 32'b0;

    assign done = (is_valid == 1'b1) ? 1'b1 : 1'b0;

    assign is_valid = (cIn == customId && start == 1'b1);

endmodule