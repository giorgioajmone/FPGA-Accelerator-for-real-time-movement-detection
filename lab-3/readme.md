Giorgio Ajmome 368146, Alessandro Cardinale 368411

In the virtual prototype the files that we added/modified are:
- in modules the directory performanceCounter contains the verilog files and the tb used to do the profilig counter: counter.v, profileCi.v, profileCi_tb.v.
- in programms/grayscale/src the grayscale.c file has been modified to add the assembly instructions to manage our performance counters.
- in systems/verilog we modified the singleCore to integrate the profileCi and connect it. To this goal we added three wires, two of them to collect the output or-ed with the global output and one to measure the CPU stalls as an input for our module