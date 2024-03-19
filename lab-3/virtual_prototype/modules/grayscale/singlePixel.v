module singlePixel (
    input wire[4:0] red, blue;
    input wire[5:0] green;
    output wire[31:0] result;
);

// RED

wire[31:0] g_red, g_red01, g_red23, g_red0, g_red1, g_red2, g_red3;

assign g_red0 = red << 5;
assign g_red1 = red << 4;
assign g_red2 = red << 2;
assign g_red3 = red << 1;

assign g_red01 = g_red0 + g_red1;
assign g_red23 = g_red2 + g_red3;

assign g_red = (g_red01 + g_red23) >> 5;

// GREEN

wire[31:0] g_green, g_green01, g_green23, g_green0, g_green1, g_green2, g_green3;

assign g_green0 = green << 7;
assign g_green1 = green << 6;
assign g_green2 = green << 3;
assign g_green3 = green;

assign g_green01 = g_green0 + g_green1;
assign g_green23 = g_green2 + g_green3;

assign g_green = (g_green01 - g_green23) >> 6;

// BLUE

wire[31:0] g_blue, g_blue01, g_blue0, g_blue1, g_blue2, g_blue3;

assign g_blue0 = blue << 4;
assign g_blue1 = blue << 1;
assign g_blue2 = blue;

assign g_blue01 = g_blue0 + g_blue1;

assign g_blue = (g_blue01 + g_blue2) >> 5;

wire[31:0] result0;

assign result0 = g_red + g_green;

assign result = (result0 + g_blue) & 32'h000000FF;
    
endmodule