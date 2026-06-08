module BcdTestBench();
    reg [7:0] bin;
    wire [11:0] bcd;

    BcdConv bdc(bin,bcd);

    initial begin
        for(bin=0;bin<255;bin=bin+1) begin
            #1
                $display("bin=%d,bcd=%h",bin,bcd);
        end
        $finish;
    end

endmodule
