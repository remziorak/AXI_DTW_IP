`timescale 1ns / 1ps

module temp_test_memory (template_data, test_data,temp_mem_addr,test_mem_addr, clk, temp_mem_write_enable,test_mem_write_enable,  temp_memory_out,test_memory_out);

	parameter N               = 32; // memory width
	parameter M               = 32; // output cell width 
	parameter Sample          = 256; // memory depth


	input   wire    [N-1:0]     template_data;
	input   wire    [N-1:0]     test_data;
	input   wire    [7:0]       temp_mem_addr;
	input   wire    [7:0]       test_mem_addr;
	input   wire                temp_mem_write_enable;
	input   wire                test_mem_write_enable;
	input   wire                clk;
//	input   wire                rst;
	output          [M-1:0]     temp_memory_out;
	output          [M-1:0]     test_memory_out;






	blk_mem_gen_32x256 template_inst(
		.clka(clk),
		.wea(temp_mem_write_enable),
		.addra(temp_mem_addr),
		.dina(template_data),
		.douta(temp_memory_out)
	);

	blk_mem_gen_32x256 test_inst(
		.clka(clk),
		.wea(test_mem_write_enable),
		.addra(test_mem_addr),
		.dina(test_data),
		.douta(test_memory_out)
	);


endmodule
