Giorgio Ajmome 368146, Alessandro Cardinale 368411

Task 2

In the file virtual_prototype/modules/camera/camera.v has been modified to insert the grayscale conversion.
At line 178 there is the code added/modified:
two wires of 8 bits s_MSPixel and s_LSPixel are defined. They will be the frayscalevalues of the first and second pixel received respectively.
Indeed, two grayscale modules are included: thez receive the two pixels as inputs and output the two grayscale values.
The two grayscale pixels are then converted into an RGB version of the,selves, as explained in the assignement, and assigned to the 32 bit word s_grayscalePixelWord. s_grayscalePixelWord is then saved in the òine buffer.

Task 3

In this task we transmit 4 pixels each time because they are kept at 8-bit grayscale. This means we have to deal with 8 bytes.
Thez are concatenated in s_pixelDoubleWord, using a 16-bits swapping.
Each couple of bytes is then converted to grayscale with four instances of the grayscale module. The grayscale pixels are assigned to the four bytes of s_grayscalePixelWord, following the order of arrival (most recent pixel in the MS byte of the word).
s_grayscalePixelWord is stored in the line buffer, however a modification must be done: the address must be sliced in the range [10:3] as now we are dealing with double the data. The write enable of the buffer must be set when s_pixelCountReg[2:0] = 3'b111 as we now need to count up to 8 bytes before storing the word in the buffer. 
Finally, at line 255, s_nrOfPixelsPerLineReg must be assigned s_pixelCountValueReg[10:3] when s_newLine == 1'b1 as double of pixels are sent in the bus.
