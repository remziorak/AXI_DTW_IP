`timescale 1ns / 1ps

module dtw_value_comp(distance, states, en, clk, rst, even_douta, even_doutb, odd_douta,odd_doutb, dtw_cell_out ) ;
	parameter N = 32;
    parameter M = 24;
	input [M-1:0] distance;
	input [N-1:0] even_douta;
	input [N-1:0] even_doutb;
	input [N-1:0] odd_douta;
	input [N-1:0] odd_doutb;
	input [3:0] states;


	input en;
	input clk;
	input rst;
	output reg [N-1:0] dtw_cell_out;
	wire [N-1:0] min_out;

	reg [3:0] current_state;

	reg [N-1:0] vector1;
	reg [N-1:0] vector2;
	reg [N-1:0] vector3;

always @(states)
begin
    current_state = states;
end

	always @(posedge clk)
	begin
		if(rst)
			begin
				vector1 = 32'd0;
				vector2 = 32'd0;
				vector3 = 32'd0;
				dtw_cell_out = 32'd0;
			end
		else if(~en)
			begin
				vector1 = 32'd0;
				vector2 = 32'd0;
				vector3 = 32'd0;
				dtw_cell_out = 32'd0;
			end
		else
			begin
				case(current_state)
					0: begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = 32'd0;
					end
					1:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = 32'd0;
					end
					2:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = 32'd0;
					end
					3:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = distance;
					end
					4:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = distance + even_doutb;
					end
					5:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = distance + even_douta;
					end

					6:begin
						vector1 = even_douta;
						vector2 = even_doutb;
						vector3 = odd_doutb;
						dtw_cell_out = distance + min_out;
					end
					7:begin
						vector1 = 32'd0;
						vector2 = 32'd0;
						vector3 = 32'd0;
						dtw_cell_out = distance + odd_douta;
					end
					8:begin
						vector1 = odd_douta;
						vector2 = odd_doutb;
						vector3 = even_doutb;
						dtw_cell_out = distance + min_out;
					end
					default:begin
						vector1 = vector1;
						vector2 = vector2;
						vector3 = vector3;
						dtw_cell_out = dtw_cell_out;
					end
				endcase
			end
	end


	minimum_of_3_vector minimum_of_3_vector_inst(.vector1(vector1),
		.vector2(vector2),
		.vector3(vector3),
		.out(min_out) );

endmodule
