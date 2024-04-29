Giorgio Ajmome 368146, Alessandro Cardinale 368411

Inside virtual_prototype/modules the folder DMA has been created. That holds all the verilog files related to our DMA module.
Among them there are:
- dualPortSSRAM.v that contains a true dual port SSRAM, where the two ports A and B have each their own clock, WriteEnamle signal, address and dataIn/Out ports.
- DMAController.v is the module that controls and defines all the DMA operations.
- ramDmaCi.v is the top level module where the Ci Memory and the DMA controller are instantiated and connected together, the CPU-Ci Memory transaction is controlled and done and result outputs are set.

2.2 Ci Attached Memory

This operation is dealt with in the top level ramDmaCi module.
When the bits valueA[12:10] are all equal to zero, then the CPU wants to communicate directly to the Ci Memory through port A. In that case, the result of the ramDmaCi becomes the dataOut of port A of the Ci memory and the done signal is raised directly from the memory (not from the DMA itself).
Writing to memory: in that case, if the write enable signal is 1 we are writing data from the CPU into the Ci memory. Here the done signal is set asynchronously if the CPU is executing the custom instruction and valueA[12:10] = 0 (is_memory signal).
Reading from memory: here we take into account the two-cycles delay of a reading operation using a counter. The done signal is set when the counter hits 2. After that the counter authomatically resets.
Results is in both cases directly assigned to dataOutA.
During all this operations the results and done of the DMA are set to 0.

2.3 DMA to Ci Memory

In this section we configure the DMA to be able to read data from the bus and write them into the Ci memory.
At first the CPU (programmer) configures the DMA using the table at page 3 of the assignement. This configuration occurs only when the CPU is executing the Ci of the DMA.
During this part, the controller is still in the IDLE state and it stays there until it receives a correct value in the control register (either 1 to read from the bus or 2 to write to the bus).
As soon as the control register is set, the machine enters the REQUEST state where a bus request is sent to the bus arbiter. THE FSM waits for the request grated and then moves to INIT state. Here, the DMA (that we recall behaves as a master), sends to the slave all the init signals that are depicted in slides 6-10 of the Bus Architecture lecture:
Once completed the INIT phase, the FSM goes into the READ state, where it reads data from the bus (sent by the slave addressed  witht the address in the INIT phase).
During READ state, the data incoming in the DMA, that is latched to reduce the critical path, is assigned directly to the portB of the Ci memory and the WriteEnableB is set to 1. Port B of the memory is controlled by CLKb, as it is samples data at the negative edge of the clock.

Several counters are instantiated to keep track of the different parameters:
- Block Counter unpdates once each word has been received/sent. It resets at the block size
- Burst Counter also updates once each word has been received/sent but is resets at the burst size
- memAddress_r updates the address of the Ci memory
- busAddress updates the address of the bus (the slave). It is considered byte addressable, thus at each clock cycle is incremented by 4 because we assumed transactions of 32-bit long words.
- Mem Counter is used to count the 2 cycles necessary to read from the SSRAM.

Counters, define the switch to the next state of the FSM.
When we are in READ state:
if a burst has been completed but the block has not, the FSM goes back to the REQUEST state to start a new transaction;
if instead also the block has been completed then the transaction has been terminated and we go back to IDLE state.

At the end of every READ operation, if we go back to the REQUEST, in the following INIT phase the init signals will be updated with the new versions, according to the requirements of the transaction. Burst size has also been implemented such that it works even when the block size is not a multiple of the initial burst size.

If, when in READ, an error is received, we set the error signal in the status register and the transaction is closed by entering in state CLOSE.

2.4 DMA from the Ci Memory

In this last point, the DMA is responsible of reading data from the memory and writing it to a slave.

Up to the READ state, the steps are the same of previous points. The counters work in the same way too.
This however, after the INIT state we enter the WRITE state and wee stay there until the transaction is ended, that occurs whent all the words of a burst have been sent.
Errors are dealt the same way as in the READ state.
At the end of a transaction there are two possibilities: either the block has been completed and we close the transaction (state CLOSE), send an end_transaction and go back to IDLE, or we still send a end_transaction but then return to state REQUEST (state C2R).

When in WRITE state, the addressDataOut is assigned asynchronously the value read from the Ci Memory. It is not latched before getting sent into the BUS. That is  because that operation was jeopardizing the functionality of the system. Despite that, the logic from the regiters of the memory to the output port has been minimized to avoid timing issues.

For both type of transactions: when DMA starts operation it sets the status register to 1. When it finishes, it sets the status register back to zero.

Inside DMAController it is also defined the logic to let the CPU read the settings from the DMA. In case this operation is called by the CPU, the result of the top module ramDmaCi is assigned with the value of the setting the programmer is asking.

GENERAL REMARK: we remark that, even though we did not enter in all the details of the system, the protocol implemented is the same of the lectures.

TESTING

The first testing has been done with a testbench, then the whole system has been uploaded on the board and tested with a C code contained in programmms/DMA/src.
In the C code the following testing operations are carried out:
- Initialize an array in the SDRAM. The SDRAM will be the slave with which the DMA will communicate.
- Write a set of known values into the Ci memory of the DMA
- Configure the DMA
- Read the configuration settings from the DMA
- Set the control register to 1 so to start a read from bus write to Ci memory transaction
- Poll the status register of the DMA to see when it has finished its operation.
- Three test are done for from bus to memory trasaction: block multiple of burst, block not multiple of burst and burst greater than block.
- At the end we read the values from the Ci memory and from the Array and by comparing them we can verify the correctness of the system.
- Initiliaze the Ci memory with new values
- Write the configuration settings to the DMA
- Start to transfer data from the Ci memory to the BUS. The same three cases of the reading are tested.
- Poll the end of DMA operation as done before.
- Read data from the Ci Memory and from the Array and compare them.

After testing, all the three parts of the assignement are correctly functioning.
