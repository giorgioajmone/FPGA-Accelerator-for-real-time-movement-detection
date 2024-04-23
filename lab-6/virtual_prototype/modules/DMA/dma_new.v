module dma_new (input wire  clock, reset,
                            readBusStartAddress, writeBusStartAddress,
                            readMemoryStartAddress, writeMemoryStartAddress,
                            readBlockSize, writeBlockSize,
                            readBurstSize, writeBurstSize,
                            readStatusRegister, writeControlRegister,
                input wire dmaAckBusIn, dmaBusErrorIn, dmaBusyIn,
                input wire [31:0] ci_valueBIn, ssram_outBIn,
                output wire writeEnableBOut,
                output wire dmaRequestBusOut, dmaBeginTransactionOut, dmaReadNotWriteOut,
                output wire [3:0] dmaByteEnablesOut,
                output wire [7:0] dmaBurstSizeOut,
                output wire [8:0] ssram_addressBOut,
                output wire [31:0] ci_resultOut,
                input wire dmaDataValidIn,dmaEndTransactionIn,
                output wire dmaDataValidOut,dmaEndTransactionOut,
                input wire [31:0] dmaAddressDataIn,
                output wire [31:0] dmaAddressDataOut);

    // declare FSM states
    parameter IDLE                      = 9'b0000_00000;
    parameter WAIT_GRANT_READ           = 9'b0001_00001;
    parameter WAIT_GRANT_WRITE          = 9'b0010_00001;
    parameter BEGIN_TRANSACTION_READ    = 9'b0011_01010;
    parameter BEGIN_TRANSACTION_WRITE   = 9'b0100_01000;
    parameter READ_BURST                = 9'b0101_00000;
    parameter WRITE_BURST               = 9'b0110_00100;
    parameter NEW_REQUEST_WRITE         = 9'b0111_10000;
    parameter END_TRANSACTION_WRITE     = 9'b1000_10000;
    parameter ERROR                     = 9'b1001_10000;

    reg [8:0] state;
    assign dmaRequestBusOut = state[0];
    assign dmaReadNotWriteOut = state[1];
    assign dmaDataValidOut = state[2];
    assign dmaBeginTransactionOut = state[3];
    assign dmaEndTransactionOut = state[4];
    assign writeEnableBOut = (state == READ_BURST) ? dmaDataValidIn : 1'b0;

    // declare internal registers
    reg [31:0] busStartAddress;
    reg [8:0] memoryStartAddress;
    reg [9:0] blockSize;
    reg [7:0] burstSize;
    reg [31:0] status;
    reg [1:0] control;
    reg [31:0] result_reg;

    // dma config read/write
    always @(posedge clock or posedge reset)
    begin
        if (reset) begin
            result_reg <= 32'h0000_0000;
            busStartAddress <= 32'h0000_0000;
            memoryStartAddress <= 9'h000;
            blockSize <= 10'h000;
            burstSize <= 8'h00;
            control <= 2'b00;
        end

        // handle register reading (only signal can be high at the same time due to custom instruction)
        else if (readBusStartAddress)
            result_reg <= busStartAddress;
        else if (readMemoryStartAddress)
            result_reg <= {23'h000000,memoryStartAddress};
        else if (readBlockSize)
            result_reg <= {22'h000000,blockSize};
        else if (readBurstSize)
            result_reg <= {24'h000000,burstSize};
        else if (readStatusRegister)
            result_reg <= status;

        // handle register writing
        else if (writeBusStartAddress)
            busStartAddress <= ci_valueBIn;
        else if (writeMemoryStartAddress)
            memoryStartAddress <= ci_valueBIn[8:0];
        else if (writeBlockSize)
            blockSize <= ci_valueBIn[9:0];
        else if (writeBurstSize)
            burstSize <= ci_valueBIn[7:0];
        else if (writeControlRegister)
            control <= ci_valueBIn[1:0];
        else
            //result_reg <= result;
            control <= 2'b00; // take the start instruction away
    end
    assign ci_resultOut = result_reg;


    // FSM registers
    reg [7:0] burstSize_counter;
    reg [7:0] current_transaction_burstSize;
    reg [9:0] resting_blockSize;
    reg [8:0] memoryAddress;
    reg [31:0] busAddress;

    reg [3:0] dmaByteEnables_reg;
    reg [7:0] dmaBurstSize_reg;
    reg [31:0] dmaAddressData_reg;

    // assign FSM registers to outputs
    assign dmaByteEnablesOut = dmaByteEnables_reg;
    assign dmaBurstSizeOut = dmaBurstSize_reg;
    assign dmaAddressDataOut = dmaAddressData_reg;
    assign ssram_addressBOut = memoryAddress;

    // DMA FSM
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            resting_blockSize <= 10'h000;
            burstSize_counter <= 8'h00;
            current_transaction_burstSize <= 8'h00;
            memoryAddress <= 9'h000;
            status <= 32'h0000_0000;

            dmaByteEnables_reg <= 4'b0000;
            dmaBurstSize_reg <= 8'h00;
            dmaAddressData_reg <= 32'h0000_0000;

            state <= IDLE;
        end

        else begin
            case (state)
                IDLE: begin
                    if ((control[0] && ~control[1]) || (~control[0] && control[1])) begin
                        status <= 32'h0000_0001;
                        memoryAddress <= memoryStartAddress;
                        busAddress <= busStartAddress;
                        resting_blockSize <= blockSize;
                        if (control[0]) state <= WAIT_GRANT_READ;
                        else state <= WAIT_GRANT_WRITE;
                    end else begin
                        memoryAddress <= 9'h000;
                        busAddress <= 32'h0000_0000;

                        dmaByteEnables_reg <= 4'b0000;
                        dmaBurstSize_reg <= 8'h00;
                        dmaAddressData_reg <= 32'h0000_0000;
                    end
                end

                WAIT_GRANT_READ: begin
                    if (dmaAckBusIn) begin
                        dmaByteEnables_reg <= 4'b1111;
                        if ((burstSize + 1) <= (resting_blockSize)) begin
                            dmaBurstSize_reg <= burstSize;
                            current_transaction_burstSize <= burstSize;
                            resting_blockSize <= resting_blockSize - (burstSize + 1);
                        end else begin
                            dmaBurstSize_reg <= (resting_blockSize - 1);
                            current_transaction_burstSize <= (resting_blockSize - 1);
                            resting_blockSize <= 10'h000;
                        end
                        burstSize_counter <= 8'h00;
                        dmaAddressData_reg <= busAddress;
                        state <= BEGIN_TRANSACTION_READ;
                    end
                end

                WAIT_GRANT_WRITE: begin
                    if (dmaAckBusIn) begin
                        dmaByteEnables_reg <= 4'b1111;
                        if ((burstSize + 1) <= (resting_blockSize)) begin
                            dmaBurstSize_reg <= burstSize;
                            current_transaction_burstSize <= burstSize;
                            resting_blockSize <= resting_blockSize - (burstSize + 1);
                        end else begin
                            dmaBurstSize_reg <= (resting_blockSize - 1);
                            current_transaction_burstSize <= (resting_blockSize - 1);
                            resting_blockSize <= 10'h000;
                        end
                        burstSize_counter <= 8'h00;
                        dmaAddressData_reg <= busAddress;
                        state <= BEGIN_TRANSACTION_WRITE;
                    end
                end

                BEGIN_TRANSACTION_READ: begin
                    dmaByteEnables_reg <= 4'b0000;
                    dmaBurstSize_reg <= 8'h00;
                    burstSize_counter <= 8'h00;
                    dmaAddressData_reg <= 32'h0000_0000;
                    state <= READ_BURST;
                end

                BEGIN_TRANSACTION_WRITE: begin
                    dmaByteEnables_reg <= 4'b0000;
                    dmaBurstSize_reg <= 8'h00;
                    burstSize_counter <= 8'h00;
                    dmaAddressData_reg <= ssram_outBIn;
                    memoryAddress <= memoryAddress + 1;
                    state <= WRITE_BURST;
                end

                READ_BURST: begin
                    if (dmaBusErrorIn) state <= ERROR;
                    else begin
                        if (dmaDataValidIn) begin
                            memoryAddress <= memoryAddress + 1;
                        end
                        if (dmaEndTransactionIn) begin
                            if (resting_blockSize == 10'h000) begin
                                status <= 32'h0000_0000;
                                state <= IDLE;
                            end
                            else begin // request a new read transfer with updated busAddress
                                //busAddress <= busAddress + (burstSize + 1)
                                busAddress <= busAddress + (burstSize << 2) + 4; // bus addressing in bytes
                                state <= WAIT_GRANT_READ;
                            end
                        end
                    end
                end

                WRITE_BURST: begin
                    if (dmaBusErrorIn) state <= ERROR;
                    else begin
                        if (~dmaBusyIn) begin
                            if (burstSize_counter == current_transaction_burstSize) begin
                                dmaAddressData_reg <= 32'h0000_0000;
                                if (resting_blockSize == 10'h00) state <= END_TRANSACTION_WRITE;
                                else state <= NEW_REQUEST_WRITE;
                            end else begin
                                memoryAddress <= memoryAddress + 1;
                                dmaAddressData_reg <= ssram_outBIn;
                                burstSize_counter <= burstSize_counter + 1;
                            end
                        end
                    end
                end

                NEW_REQUEST_WRITE: begin
                    if (dmaBusErrorIn) state <= ERROR;
                    else begin
                        //memoryAddress <= memoryAddress + 1;
                        busAddress <= busAddress + (burstSize << 2) + 4; // bus addressing in bytes
                        state <= WAIT_GRANT_WRITE;
                    end
                end

                END_TRANSACTION_WRITE: begin
                    status <= 32'h0000_0000;
                    state <= IDLE;
                end

                ERROR: begin
                    status <= 32'h0000_0002;
                    state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end

    end



endmodule
