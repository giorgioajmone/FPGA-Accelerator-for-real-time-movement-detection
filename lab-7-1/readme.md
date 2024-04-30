Giorgio Ajmome 368146, Alessandro Cardinale 368411

In the virtual prototype the files that we added/modified are:
- in modules the directory grayscale contains the verilog files that describe the graysclae conversion in hardware. 
  singlePixel.v is the module that describes the rgb565 to grayscale conversion
  rgb565grayscaleIse.v is the top level modue. There we instantiate singlePixel.v
- in systems/singleCore/or1420SingleCore.v we instantiated the rgb565grayscaleIse.v module and mappedd it to the system signals. We   created two signals, one for the result and one for the done, called s_grayResult and s_grayDone and ored them to the other results/done in the assign of the global result.
- in programms/grayscale/src/grayscale.c we introduced an assembly line of code in the for loop of the conversion to make the system execute our custom instruction.

ANSWER TO QUESTIONS
Note: we report one measurement here. Different measurements produced different values, but within the same order, thus one single measurement will be enough to see the effects of the custom instruction.

Unmodified grayscale cycles
Execution cycles: 30684774
Stall cycles: 19004445
Bus idle cycles: 16930050
Real cycles: Execution cycles - Stall cycles = 11680329

Modified grayscale cycles
Execution cycles: 24496408
Stall cycles: 18345679
Bus idle cycles: 11561218
Real cycles: Execution cycles - Stall cycles = 6150729

When using a custom instruction, the number of real cycles is approximately halved.


Brief explanation of the logic behind the accelerated grayscale conversion:

The idea behind our implementation was to transform the multiplication into shifting and addition/subtraction operation.
For all three colors, we tried to follow a binary-tree like architecture, in the following way:
First of all, being the initial algorithm (RED*54 +  GREEN*183 + BLUE*19)/256 one can think of dealing with the three colors in parallel.
For each color the operation to execute is COLOR*W, wheree W represents the weight of each color.
To get rid of the multiplication, one can rewrite W as W = (A + B + C + D), where A, B, C, D are powers of two. Then, the operation becomes: 
COLOR * W = COLOR * (A + B + C + D) = COLOR*A + COLOR*B + COLOR*C + COLOR*D, but, being A, B, C, D powers of two, those multiplications becomen simple left-shifting operations of log2(i), i = A,B,C,D that can be executed in parallel.
This shiftings give rise to 4 operands that can be subsequently added.
Also for the addition some parallelization can be be exploited: 
(COLOR*A + COLOR*B) and (COLOR*C + COLOR*D) can be executed together by two adders working in parallel and their respective results can then be added together by a third adder, that outputs COLOR*W. Here it is evident the binary-tree nature of our architecture.
This kind of operation is done in parallel for all the colors, and the results are then summed together to get the final grayscale pixel.
Also to deal with the division by 256 some modifications are done. In the C code provided, RED and BLUE are left-shifted by 3 and GREEN by 2 and the final result is right-shifted by 8. In our implementation, we decided to left-shift of 1 then RED and BLUE and of 0 the GREEN and then to right-shift everything by just 6 at the end.
The left shift of 1 bit is included into the left shift that performs the multiplication COLOR*i, i = A,B,C,D.
Details for each color are given in the following.

RED
Red must be multiplied by 54. Rewrite 54 as (32 + 16 + 4 + 2).
Here, in the left shifting, 1 bit more is included, as explained before.

GREEN
To mantain the same architecture for each color, 183 can be rewritten as (128 + 64 - 8 - 1).
Notice that 183 could also be rewritten as (128 + 32 + 16 + 4 + 2 +1), but this would require us a larger amount of adders that would worsen the area consumption as well as the performance of our system. Thus, the choice is to use a subtracter in the third stage of our path to maintain our binary-tree fashion and to have a lower timing and area overhead.

BLUE
Blue must be multiplied 19, that can be rewrittene as (16 + 2 + 1).
Also for the blue, as for the red, one bit more is included in the left-shifting.

Finally, the three intermediate results are added together and are right shifted of 6 bits.
