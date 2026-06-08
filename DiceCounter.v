module DiceCounter (reset,clk,dice);
    input reset;
    input clk;
    output [2:0] dice;
    reg [2:0] cnt;
    assign dice=cnt;

    always@(posedge reset or posedge clk) begin
        if(reset)
            cnt=0;
        else if (cnt==3'd5)
            cnt=0;
        else
            cnt=cnt+1;
    end
endmodule

module DiceTestBench();
    reg reset;
    reg clk;
    wire [2:0] dice;

    DiceCounter dc(reset,clk,dice);

    always #5 clk=~clk;
    initial begin
        $monitor("reset=%b,clk=%b,dice=%d",reset,clk,dice);
        reset=1;
        clk=0;
        #10
        reset=0;
        #300
        $finish;
    end
endmodule
