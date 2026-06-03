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
