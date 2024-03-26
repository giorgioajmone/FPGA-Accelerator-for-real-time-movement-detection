module gpio #(
    parameter[31:0] baseAddress = 32'h40000000, 
    parameter inPorts = 1,
    parameter outPorts = 1
) (
    inout wire[31:0] address_data,
    inout wire[3:0] byte_enables,
    inout wire[7:0] burst_size,
    inout wire read_n_write, begin_transaction, end_transaction, data_valid, busy, error
    input wire[1023:0] inputs, 
    output wire[1023:0] outputs,
    input wire clock, reset
);

parameter IDLE = 3'd0;
parameter READ = 3'd1;
parameter WRITE = 3'd2;
parameter END_READ = 3'd3;
parameter ERROR = 3'd4;

reg wire[31:0] address_data_r;
reg wire[3:0] byte_enables_r;
reg wire[7:0] burst_size_r
reg wire read_n_write_r, begin_transaction_r, end_transaction_r, data_valid_r, busy_r, error_r;

reg[31:0] address;
reg[2:0] state;

assign error = (state == ERROR ? 1'b1 : 1'b0);

assign outputs[32*((address - baseAddress)+1)-1-1024:32*((address - baseAddress))-1024] = state == WRITE && data_valid_r == 1'b1 ? address_data_r : 32'b0;

assign address_data[0:31] = state == READ && (address-baseAddress) < inPorts ? inputs[[32*((address - baseAddress)+1)-1:32*((address - baseAddress))]] : 32'b0;

assign end_transaction = state == END_READ ? 1'b1 : 1'b0;

assign data_valid = state == READ ? 1'b1 : 1'b0;

assign busy = 1'b0;

always @(posedge clock) begin
    address_data_r <= address_data;
    byte_enables_r <= byte_enables;
    burst_size_r <= burst_size;
    read_n_write_r <= read_n_write;
    begin_transaction_r <= begin_transaction; 
    end_transaction_r <= end_transaction;
    data_valid_r <= data_valid;
    busy_r <= busy;
    error_r <= error;
end

always @(posedge clock) begin
    if (reset) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (begin_transaction_r && address >= baseAddress && address < baseAddress+64) begin
                    if(byte_enables_r != 4'b1) begin
                        state <= ERROR; 
                    end else if (read_n_write_r == 1'b0) begin
                        state <= WRITE;
                        address <= address_data_r;
                    end else if (read_n_write_r == 1'b0) begin
                        state <= READ;
                        address <= address_data_r;
                    end else begin
                        state <= IDLE;
                    end
                end else begin
                    state <= IDLE;
                end
            end
            ERROR: begin
                state <= IDLE;
            end
            WRITE: begin
                if (end_transaction_r == 1'b1) begin
                    state <= IDLE;
                end else begin
                    state <= WRITE;
                end
            end
            READ: begin
                state <= END_READ;
            end
            END_READ: begin
                state <= IDLE;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end
    
endmodule