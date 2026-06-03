module StopWatch(clk,btn,sw,led,hled0,hled1,hled2,hled3);
    input clk;
    input [2:0] btn;
    input [9:0] sw;
    output [9:0] led;
    output [7:0] hled0;
    output [7:0] hled1;
    output [7:0] hled2;
    output [7:0] hled3;
    // wire and register
    wire ss_btn,ss_nreset;
    wire [3:0] cout;    // carry out
    reg ss_ff;          // Start/Stop Flip-Flop
    wire iclk;          // 1/100s clock
    // decimal counter wire
    wire [3:0] dout0;
    wire [3:0] dout1;
    wire [3:0] dout2;
    wire [3:0] dout3;
    // Hex output wire
    wire [7:0] whex0;
    wire [7:0] whex1;
    wire [7:0] whex2;
    wire [7:0] whex3;

    // unused output
    assign led=10'h0;

    // Button2
    unchatter unc(btn[2],clk,ss_btn);

    // Start/Stop FF Reset signal
    // 90.00で2回止まった
    // assign ss_nreset=btn[1] & ~cout[3];
    // 99.99で2回止まった
    //assign ss_nreset = ~(~btn[1] | cout[3]);
    // 止まらずに00.00になってスタートした
    assign ss_nreset = btn[1];
    // Start/Stop Flip Flop
    always@(negedge ss_btn or negedge ss_nreset) begin
        if(ss_nreset==1'b0)
            ss_ff=0;
        else
            ss_ff=~ss_ff;
    end

    // 10ms Timer
    Timer #(10) TM(clk,iclk);

    // decimal counter
    ucounter #(9) uc0(iclk,btn[1],ss_ff,cout[0],dout0);
    ucounter #(9) uc1(iclk,btn[1],cout[0],cout[1],dout1);
    ucounter #(9) uc2(iclk,btn[1],cout[1],cout[2],dout2);
    ucounter #(9) uc3(iclk,btn[1],cout[2],cout[3],dout3);

    // Hex output
    HexSegDec hs0(dout0,whex0);
    HexSegDec hs1(dout1,whex1);
    HexSegDec hs2(dout2,whex2);
    HexSegDec hs3(dout3,whex3);
    assign hled0=whex0;
    assign hled1=whex1;
    assign hled2={1'b0,whex2[6:0]};
    assign hled3=whex3;

endmodule
