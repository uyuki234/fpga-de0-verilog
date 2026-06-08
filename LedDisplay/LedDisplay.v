module FontRom(radr,dat);
    input [4:0] radr;
    output [9:0] dat;
    function [9:0] FontDec;
        input [4:0] dadr;
        begin
            case(dadr)
			5'd00:  FontDec=10'h006;
			5'd01:  FontDec=10'h382;
			5'd02:  FontDec=10'h2bb;
			5'd03:  FontDec=10'h2aa;
			5'd04:  FontDec=10'h2ea;
			5'd05:  FontDec=10'h2ab;
			5'd06:  FontDec=10'h2aa;
			5'd07:  FontDec=10'h2bb;
			5'd08:  FontDec=10'h382;
			5'd09:  FontDec=10'h006;
			5'd10:  FontDec=10'h000;
			5'd11:  FontDec=10'h082;
			5'd12:  FontDec=10'h28a;
			5'd13:  FontDec=10'h2ab;
			5'd14:  FontDec=10'h1ae;
			5'd15:  FontDec=10'h1ab;
			5'd16:  FontDec=10'h3fa;
			5'd17:  FontDec=10'h1ab;
			5'd18:  FontDec=10'h1ab;
			5'd19:  FontDec=10'h2ab;
			5'd20:  FontDec=10'h28a;
			5'd21:  FontDec=10'h082;
			5'd22:  FontDec=10'h000;
			5'd23:  FontDec=10'h07c;
			5'd24:  FontDec=10'h044;
			5'd25:  FontDec=10'h044;
			5'd26:  FontDec=10'h044;
			5'd27:  FontDec=10'h3ff;
			5'd28:  FontDec=10'h044;
			5'd29:  FontDec=10'h044;
			5'd30:  FontDec=10'h044;
			5'd31:  FontDec=10'h07c;
            endcase
        end
    endfunction
    assign dat=FontDec(radr);
endmodule

module LedDisplay(clk,btn,sw,led,hled0,hled1,hled2,hled3);
    input clk;
    input [2:0] btn;
    input [9:0] sw;
    output [9:0] led;
    output [7:0] hled0;
    output [7:0] hled1;
    output [7:0] hled2;
    output [7:0] hled3;
    wire reset,msclk;
    wire [9:0] fdat;
    reg [4:0] areg;

    assign hled0=8'hff;
    assign hled1=8'hff;
    assign hled2=8'hff;
    assign hled3=8'hff;

    assign reset=btn[2];
    // 10ms Timer
    Timer #(4) tm(clk,msclk);
    // adr reg
    always @(posedge msclk or posedge reset) begin
        if(reset==1'b1) begin
            areg=5'h00;
        end
        else begin
            areg=areg+1;
        end
    end

    // FontDec data
    FontRom fr(areg,fdat);
    assign led=(reset==1'b1) ? 10'h00 : fdat;
endmodule
