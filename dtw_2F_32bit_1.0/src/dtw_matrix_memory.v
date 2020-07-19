`timescale 1ns / 1ps

module dtw_matrix_memory (data_in, even_addra, even_addrb,odd_addra, odd_addrb, clk, even_mem_write_enable,odd_mem_write_enable, even_douta, even_doutb, odd_douta, odd_doutb);

	parameter N               = 32; // memory width
	parameter M               = 32; // output cell width 
	parameter Sample          = 256; // memory depth


	input   wire    [N-1:0]     data_in;
	input   wire    [7:0]       even_addra;
	input   wire    [7:0]       even_addrb;
	input   wire    [7:0]       odd_addra;
	input   wire    [7:0]       odd_addrb;
	input   wire                even_mem_write_enable;
	input   wire                odd_mem_write_enable;
	input   wire                clk;

	//input   wire                rst;
	output          [M-1:0]     even_douta;
	output          [M-1:0]     even_doutb;
	output          [M-1:0]     odd_douta;
	output          [M-1:0]     odd_doutb;

blk_mem_gen_dual_256x32 odd_rows(
  .clka(clk),
  .wea(odd_mem_write_enable),
  .addra(odd_addra),
  .dina(data_in),
  .douta(odd_douta),
  .clkb(clk),
  .enb(1'b1),
  .web(1'b0),
  .addrb(odd_addrb),
  .dinb(data_in),
  .doutb(odd_doutb)
);

blk_mem_gen_dual_256x32 even_rows(
  .clka(clk),
  .wea(even_mem_write_enable),
  .addra(even_addra),
  .dina(data_in),
  .douta(even_douta),
  .clkb(clk),
  .enb(1'b1),
  .web(1'b0),
  .addrb(even_addrb),
  .dinb(data_in),
  .doutb(even_doutb)
);

endmodule
