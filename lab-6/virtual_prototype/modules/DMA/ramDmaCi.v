module ramDmaCi #(
    parameter[7:0] customId = 8'h00
) (
    input wire      start,
                    clock,
                    reset,
    input wire[31:0] valueA, valueB,
    input wire[7:0] ciN,
    output wire done, 
    output wire[31:0] result,

    //bus ports
    input wire[31:0] address_data_in,
    output wire[31:0] address_data_out,
    output wire[3:0] byte_enables_out,
    output wire[7:0] burst_size_out,
    output wire read_n_write_out, begin_transaction_out, end_transaction_out, data_valid_out,
    input wire end_transaction_in, data_valid_in, busy_in, error_in,
    input wire grantRequest,
    output wire busRequest
);

    reg[1:0] counter;

    reg[3:0] byte_enables_out_r;
    reg[7:0] burst_size_out_r;
    reg[31:0] address_data_out_r;
    reg read_n_write_out_r, begin_transaction_out_r, end_transaction_out_r, data_valid_out_r, busRequest_r;

    wire[3:0] byte_enables_out_s;
    wire[7:0] burst_size_out_s;
    wire[31:0] address_data_out_s;
    wire read_n_write_out_s, begin_transaction_out_s, end_transaction_out_s, data_valid_out_s, busRequest_s;

    reg[31:0] address_data_in_r;
    reg end_transaction_in_r, data_valid_in_r, busy_in_r, error_in_r,
        grantRequest_r;

    wire is_valid, is_memory;
    wire[1:0] status;

    wire[31:0] dataOutA, resultMem, resultDMA;
    wire doneMem, doneDMA;

    wire[8:0] memAddress;
    wire[31:0] memDataIn, memDataOut;
    wire memWriteEnable;

    assign byte_enables_out <= byte_enables_out_r;
    assign burst_size_out <= burst_size_out_r;
    assign address_data_out <= address_data_out_r;
    assign read_n_write_out <= read_n_write_out_r;
    assign begin_transaction_out <= begin_transaction_out_r;
    assign end_transaction_out <= end_transaction_out_r;
    assign data_valid_out <= data_valid_out_r;
    assign busRequest_r <= busRequest_r;

    assign doneDMA = (is_valid == 1'b1 && ~is_memory) ? 1'b1 : 1'b0;
    assign doneMem = (is_valid == 1'b1 && is_memory && (counter == 2'd2 || valueA[9] == 1'b1) )? 1'b1 : 1'b0;

    assign resultMem = (is_valid == 1'b1 && is_memory) ? dataOutA : 32'b0;

    assign done = doneDMA | doneMem;
    assign result = resultMem | resultDMA;

    assign is_valid = (ciN == customId && start == 1'b1);
    assign is_memory = (valueA[12:10] == 3'b0);

    always @(posedge clock) begin
        if (reset == 1'b1) begin
            end_transaction_in_r <= 0;
            data_valid_in_r <= 0;
            busy_in_r <= 0;
            error_in_r <= 0;
            grantRequest_r <= 0;
            address_data_in_r <= 0;

            byte_enables_out_r <= 0;
            burst_size_out_r <= 0;
            address_data_out_r <= 0;
            read_n_write_out_r <= 0;
            begin_transaction_out_r <= 0;
            end_transaction_out_r <= 0;
            data_valid_out_r <= 0;
            busRequest_r <= 0;
        end else begin
            end_transaction_in_r <= end_transaction_in;
            data_valid_in_r <= data_valid_in;
            busy_in_r <= busy_in;
            error_in_r <= error_in;
            grantRequest_r <= grantRequest;
            address_data_in_r <= address_data_in;

            byte_enables_out_r <= byte_enables_out_s;
            burst_size_out_r <= burst_size_out_s;
            address_data_out_r <= address_data_out_s;
            read_n_write_out_r <= read_n_write_out_s;
            begin_transaction_out_r <= begin_transaction_out_s;
            end_transaction_out_r <= end_transaction_out_s;
            data_valid_out_r <= data_valid_out_s;
            busRequest_r <= busRequest_s;
        end
    end

    // modification: logic for counter
    always@(posedge clock) begin
        if(reset == 1'b1) begin
            counter = 0;
        end else begin
            counter <= (counter == 2'd2 || !is_valid || valueA[9] == 1'b1) ? 2'd0 : counter + 1;
        end

    end

    dualPortSSRAM #(.bitwidth(32), .nrOfEntries(512), .readAfterWrite(0)) memory(
        .clockA(clock),
        .clockB(~clock),
        .writeEnableA(is_valid && valueA[9] && is_memory),
        .writeEnableB(memWriteEnable),
        .addressA(valueA[8:0]),
        .addressB(memAddress),
        .dataInA(valueB),
        .dataInB(memDataOut),
        .dataOutA(dataOutA),
        .dataOutB(memDataIn)
    );

    DMAController dmaController(
        .validInstruction(is_valid),
        .writeEnable(valueA[9]),
        .clock(clock),
        .reset(reset),
        .configurationBits(valueA[12:10]),
        .readSettings(resultDMA),
        .writeSettings(valueB),
        .status(status),

        .memAddress(memAddress),
        .memDataIn(memDataIn),
        .memDataOut(memDataOut),
        .memWriteEnable(memWriteEnable),

        //bus ports
    .address_data_in(address_data_in_r),
    .address_data_out(address_data_out_s),
    .byte_enables_out(byte_enables_out_s),
    .burst_size_out(burst_size_out_s),
    .read_n_write_out(read_n_write_out_s), 
    .begin_transaction_out(begin_transaction_out_s), 
    .end_transaction_out(end_transaction_out_s), 
    .data_valid_out(data_valid_out_s),
    .end_transaction_in(end_transaction_in_r), 
    .data_valid_in(data_valid_in_r), 
    .busy_in(busy_in_r), 
    .error_in(error_in_r),
    .grantRequest(grantRequest_r),
    .busRequest(busRequest_s)
    );
    
endmodule