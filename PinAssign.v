module PinAssign(clk,btn,sw,led,hled0,hled1,hled2,hled3);
    input clk;
    input [2:0] btn;
    input [9:0] sw;
    output [9:0] led;
    output [7:0] hled0;
    output [7:0] hled1;
    output [7:0] hled2;
    output [7:0] hled3;

    assign led=10'h0;
    assign hled0=8'hff;
    assign hled1=8'hff;
    assign hled2=8'hff;
    assign hled3=8'hff;
endmodule
