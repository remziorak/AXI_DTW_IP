`timescale 1ns / 1ps

module memory_en_controller(dtw_state, rst, temp_mem_write_enable,test_mem_write_enable,  odd_mem_write_enable, even_mem_write_enable);

	input       [3:0]   dtw_state;
	input               rst;
	output  reg         temp_mem_write_enable;
	output  reg         test_mem_write_enable;
	output  reg         odd_mem_write_enable;
	output  reg         even_mem_write_enable;

	parameter    initial_state             = 4'd0;
	parameter    temp_fill_state           = 4'd1;
	parameter    test_fill_state           = 4'd2;
	parameter    calculate_first_cell      = 4'd3;
	parameter    calculate_first_row       = 4'd4;
	parameter    calculate_odd_first_cell  = 4'd5;
	parameter    calculate_odd_row         = 4'd6;
	parameter    calculate_even_first_cell = 4'd7;
	parameter    calculate_even_row        = 4'd8;
	parameter    final_state               = 4'd9;

	always @(dtw_state, rst)
	begin
		if(rst)
			begin
				temp_mem_write_enable = 1'b0;
				test_mem_write_enable = 1'b0;
				even_mem_write_enable = 1'b0;
				odd_mem_write_enable = 1'b0;
			end
		else
			begin
				case(dtw_state)
					initial_state   : begin //State 0
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b0;
					end

					temp_fill_state : begin //State 1
						temp_mem_write_enable = 1'b1;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b0;
					end

					test_fill_state : begin //State 2
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b1;
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b0;
					end

					calculate_first_cell : begin //State 3
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b1;
						odd_mem_write_enable = 1'b0;
					end

					calculate_first_row : begin //State 4
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b1;
						odd_mem_write_enable = 1'b0;
					end

					calculate_odd_first_cell : begin //State 5
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b1;
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
					end

					calculate_odd_row : begin //State 6
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b1;
					end

					calculate_even_first_cell : begin //State 7
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b1;
						odd_mem_write_enable = 1'b0;
					end

					calculate_even_row : begin //State 8
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b1;
						odd_mem_write_enable = 1'b0;
					end

					default : begin
						temp_mem_write_enable = 1'b0;
						test_mem_write_enable = 1'b0;
						even_mem_write_enable = 1'b0;
						odd_mem_write_enable = 1'b0;
					end
				endcase
			end
	end

endmodule

