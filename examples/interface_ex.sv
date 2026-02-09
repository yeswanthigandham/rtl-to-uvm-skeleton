interface intf #(parameter DEPTH=8, DWIDTH=16) (input logic clk);
logic	rstn;
logic	clk;
logic	wr_en;
logic	rd_en;
logic reg [DWIDTH-1:0]   dout;
logic empty;
logic full   ;
endinterface
