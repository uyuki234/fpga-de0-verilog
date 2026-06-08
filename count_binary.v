module count_binary(clk,btn,sw,led,hled0,hled1,hled2,hled3);
    input clk;
    input [2:0] btn;
    input [9:0] sw;
    output [9:0] led;
    output [7:0] hled0;
    output [7:0] hled1;
    output [7:0] hled2;
    output [7:0] hled3;
    wire [3:0] btn_pio;
    wire [7:0] led_pio;
    wire [15:0] seven_seg;

    assign btn_pio={1'b1,btn};
    count_binary_core cbc(clk,btn[0],led_pio,seven_seg);
    assign led={2'b0, led_pio[0], led_pio[1], led_pio[2], led_pio[3], led_pio[4], led_pio[5], led_pio[6], led_pio[7]};
    assign hled0={seven_seg[7], seven_seg[0], seven_seg[1], seven_seg[2], seven_seg[3], seven_seg[4], seven_seg[5], seven_seg[6]};
    assign hled1={seven_seg[15], seven_seg[8], seven_seg[9], seven_seg[10], seven_seg[11], seven_seg[12], seven_seg[13], seven_seg[14]};
    assign hled2=8'hff;
    assign hled3=8'hff;
endmodule
