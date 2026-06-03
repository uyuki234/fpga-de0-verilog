module clockdiv(iclk,oclk);
    input iclk;
    output oclk;
    reg oreg;
    reg [3:0] cnt;
    wire cntend;
    assign cntend=(cnt==4'h9) ? 1'b1 : 1'b0;
    always @(posedge iclk) begin
        if(cntend==1'b1)
            cnt=0;
        else
            cnt=cnt+1;
    end

    always @(posedge iclk)
        oreg=cntend;
    assign oclk=oreg;
endmodule

module DigitalWatch(clk,btn,sw,led,hled0,hled1,hled2,hled3);
    input clk;
    input [2:0] btn;
    input [9:0] sw;
    output [9:0] led;
    output [7:0] hled0;
    output [7:0] hled1;
    output [7:0] hled2;
    output [7:0] hled3;
    // wire and register
    wire [2:0] cout;    // carry out
    wire [2:0] cin;     // carry in
    wire sclk,mclk,hclk;
    wire msclk;      // 0.1s clock
    // decimal counter wire
    wire [7:0] dout0;
    wire [7:0] dout1;
    wire [7:0] dout2;
    // Hex output wire
    wire [7:0] whex0;
    wire [7:0] whex1;
    wire [7:0] whex2;
    wire [7:0] whex3;

    // clock inhibit
    wire clkinh;

    // 0.1s Timer
    Timer #(100) TM(clk,msclk);
    clockdiv cdiv(msclk,sclk);

    assign clkinh=(~btn[2] | ~btn[1]);
    // Clock Selector
    assign mclk=(btn[1]==1'b1) ? sclk : msclk;
    assign hclk=(btn[2]==1'b1) ? sclk : msclk;

    // carry in
    assign cin[0]=(clkinh==1'b0) ? 1'b1 : 1'b0; // 設定中に秒を停止
    assign cin[1]=(btn[1]==1'b1) ? cout[0] : 1'b1;  // 分の設定中は、そのままカウントアップ
    assign cin[2]=(btn[2]==1'b1) ? cout[1] : 1'b1;  // 時間の設定中は、そのままカウントアップ

    // decimal counter
    // Sec
    BcdCounter #(8'h59) uc0(sclk,btn[0],cin[0],cout[0],dout0);
    // min
    BcdCounter #(8'h59) uc1(mclk,1'b1,cin[1],cout[1],dout1);
    // hour
    BcdCounter #(8'h23) uc2(hclk,1'b1,cin[2],cout[2],dout2);

    // Hex output
    SevenSegmentDec hs0(dout1[3:0],whex0);
    SevenSegmentDec hs1(dout1[7:4],whex1);
    SevenSegmentDec hs2(dout2[3:0],whex2);
    SevenSegmentDec hs3(dout2[7:4],whex3);
    assign hled0=whex0;
    assign hled1=whex1;
    assign hled2={1'b0,whex2[6:0]};
    assign hled3=whex3;

    // sec display
    assign led[0]=((dout0[3:0]==4'h1)||(dout0[3:0]==4'h9)) ? 1'b1 : 1'b0;
    assign led[1]=((dout0[3:0]==4'h2)||(dout0[3:0]==4'h8)) ? 1'b1 : 1'b0;
    assign led[2]=((dout0[3:0]==4'h3)||(dout0[3:0]==4'h7)) ? 1'b1 : 1'b0;
    assign led[3]=((dout0[3:0]==4'h4)||(dout0[3:0]==4'h6)) ? 1'b1 : 1'b0;
    assign led[4]=(dout0[3:0]==4'h5) ? 1'b1 : 1'b0;
    assign led[5]=(dout0[7:4]>=4'h1) ? 1'b1 : 1'b0;
    assign led[6]=(dout0[7:4]>=4'h2) ? 1'b1 : 1'b0;
    assign led[7]=(dout0[7:4]>=4'h3) ? 1'b1 : 1'b0;
    assign led[8]=(dout0[7:4]>=4'h4) ? 1'b1 : 1'b0;
    assign led[9]=(dout0[7:4]>=4'h5) ? 1'b1 : 1'b0;
endmodule
