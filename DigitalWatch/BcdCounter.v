module BcdCounter(clk,nreset,cin,cout,data);
    parameter maxval = 8'h99;    // max
    input clk,nreset,cin;
    output cout;
    output [7:0] data;
    reg [3:0] LCnt,HCnt;
    wire clr,cntup;

    assign data = {HCnt, LCnt};
    assign cout = clr;
    assign clr = ((data == maxval) && (cin == 1'b1)) ? 1'b1 : 1'b0;
    assign cntup = (LCnt == 4'h9) ? 1'b1 : 1'b0;

    // Low Counter
    always@(posedge clk or negedge nreset) begin
        if(nreset == 1'b0) begin
            LCnt = 4'h0;
        end else begin
            if(cin == 1'b1) begin
                if((clr == 1'b1) || (LCnt == 4'h9)) begin
                    LCnt = 4'h0;
                end else begin
                    LCnt = LCnt + 1'b1;
                end
            end
        end
    end

    // High Counter
    always@(posedge clk or negedge nreset) begin
        if(nreset==1'b0) begin
            HCnt=0;
        end else begin
            if(cin==1'b1) begin
                if(clr==1'b1) begin
                    HCnt=0;
                end else begin
                    if(cntup)
                        HCnt=HCnt+1;
                end
            end
        end
    end
endmodule