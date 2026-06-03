// universal counter module
module ucounter(clk,nclr,cin,cout,q);
    parameter maxcnt=15;    // default =HEX counter
    input clk;
    input nclr;
    input cin;
    output cout;
    output [3:0] q;
    reg [3:0] cnt;

    assign q=cnt;

    always @(posedge clk or negedge nclr) begin
        if(nclr==1'b0) begin
            cnt=4'h0;
        end
        else begin
            if(cin==1'b1) begin
                if(cnt==maxcnt)
                    cnt=4'h0;
                else
                    cnt=cnt+1;
            end
        end
    end

    assign cout=((cnt==maxcnt) && (cin==1'b1)) ? 1'b1 : 1'b0;
endmodule


// chattering remover
module unchatter(din,clk,dout);
    input din;
    input clk;
    output dout;
    reg [15:0] cnt;
    reg dff;

    always @(posedge clk) begin
        cnt=cnt+1;
    end

    always @(posedge cnt[15]) begin
        dff=din;
    end

    assign dout=dff;
endmodule

// Top module
module UniversalCounter(btn2,btn1,clk,hex0,hex1);
    input btn2;
    input btn1;
    input clk;
    output [7:0] hex0;
    output [7:0] hex1;
    wire cclk,cout1,cout2;
    wire [3:0] cnt0;
    wire [3:0] cnt1;

    // chattering remover
    unchatter uc(btn2,clk,cclk);

    // octal counter
    ucounter #(7) counter1(cclk,btn1,1'b1,cout,cnt0);
    // decimal counter
    ucounter #(9) counter2(cclk,btn1,cout,cout2,cnt1);

    // 7segment decoder
    function [7:0] LedDec;
        input [3:0] num;
        begin
            case (num)
                4'h0: LedDec = 8'b11000000;   // 0
                4'h1: LedDec = 8'b11111001;   // 1
                4'h2: LedDec = 8'b10100100;   // 2
                4'h3: LedDec = 8'b10110000;   // 3
                4'h4: LedDec = 8'b10011001;   // 4
                4'h5: LedDec = 8'b10010010;   // 5
                4'h6: LedDec = 8'b10000010;   // 6
                4'h7: LedDec = 8'b11111000;   // 7
                4'h8: LedDec = 8'b10000000;   // 8
                4'h9: LedDec = 8'b10010000;   // 9
                4'ha: LedDec = 8'b10001000;   // A
                4'hb: LedDec = 8'b10000011;   // b
                4'hc: LedDec = 8'b11000110;   // C
                4'hd: LedDec = 8'b10100001;   // d
                4'he: LedDec = 8'b10000110;   // E
                4'hf: LedDec = 8'b10001110;   // F
                default: LedDec = 8'b11111111; // 全消灯
            endcase
        end
    endfunction

    assign hex0=LedDec(cnt0);
    assign hex1=LedDec(cnt1);

endmodule
