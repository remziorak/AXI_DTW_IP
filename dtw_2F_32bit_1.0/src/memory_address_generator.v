`timescale 1ns / 1ps

module memory_address_generator (en, clk, rst, sys_status, data_addr ,dtw_state, temp_mem_addr, test_mem_addr, even_addra, even_addrb, odd_addra, odd_addrb);

	input wire en;
	input wire clk;
	input wire rst;
    input       [1:0]   sys_status;
    input       [7:0]   data_addr;
	output  reg    	[3:0]   dtw_state;
	output 	reg     [7:0]   temp_mem_addr;
	output 	reg     [7:0]   test_mem_addr;
	output  reg 	[7:0]   even_addra;
	output  reg 	[7:0]   even_addrb;
	output  reg 	[7:0]   odd_addra;
	output  reg 	[7:0]   odd_addrb;


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
    
    parameter clk_max = 4'd15;

	reg [3:0] y;                       // Current state, 
	reg [8:0] state4_column_counter;   // Used during state3
	reg [8:0] state6_column_counter ;  // Used during state5
	reg [8:0] state8_column_counter ;  // Used during state7
	reg [8:0] row_counter;             // Used for rows in matrix iff counter > 255 state goes to final state
	reg [3:0] clk_counter;             // This counter used during state3, and 5. With this counter we can 
	                                   // calculate euclidean in four clock cycle  

	// FSM
	always @(posedge clk)
	begin
		if(rst)
			y <= initial_state;
		else
			begin
				case(y)
					initial_state : 	case (sys_status)
					                       2'b00 :    y <= initial_state;
					                       2'b01 :    y <= temp_fill_state;
					                       2'b10 :    y <= test_fill_state;
                                           2'b11 :    y <= calculate_first_cell;
                                        endcase
                                        
					temp_fill_state:   case (sys_status)
					                       2'b00 :    y <= initial_state;
					                       2'b01 :    y <= temp_fill_state;
					                       2'b10 :    y <= test_fill_state;
                                           2'b11 :    y <= calculate_first_cell;
                                        endcase

					test_fill_state:   case (sys_status)
					                       2'b00 :    y <= initial_state;
					                       2'b01 :    y <= temp_fill_state;
					                       2'b10 :    y <= test_fill_state;
                                           2'b11 :    y <= calculate_first_cell;
                                        endcase

					calculate_first_cell:  if(clk_counter >= clk_max)    y <= calculate_first_row;
					else                         y <=  calculate_first_cell;

					calculate_first_row:  if(state4_column_counter == 255 && clk_counter >= clk_max)    y <= calculate_odd_first_cell;
					else                         y <=  calculate_first_row;


					calculate_odd_first_cell:  if(clk_counter >= clk_max)    y <= calculate_odd_row;
					else                         y <=  calculate_odd_first_cell;

					calculate_odd_row       :  if (row_counter>255)    y<=final_state;
					else begin
						if(state6_column_counter == 255 && clk_counter >= clk_max )    y <= calculate_even_first_cell;
						else                         y <=  calculate_odd_row;
					end

					calculate_even_first_cell:  if (row_counter>255)    y<=final_state;
					else begin
					
					if(clk_counter >= clk_max)    y <= calculate_even_row;
					else                         y <=  calculate_even_first_cell;
                    end
                    
					calculate_even_row       :  if (row_counter>255)    y<=final_state;
					else begin
						if(state8_column_counter == 255 && clk_counter >= clk_max)    y <= calculate_odd_first_cell;
						else                         y <=  calculate_even_row;
					end

					final_state: if(~rst) y <= final_state;
					else                  y <= initial_state;

					default : y <= initial_state;

				endcase

			end
	end


	always @(y, rst)
	begin
		if(rst)
			dtw_state = 4'd0;
		else
			dtw_state = y;
	end


	always @(posedge clk)
	begin
		if(rst)
			begin
				row_counter = 9'd0;
				state4_column_counter = 9'd0;
				state6_column_counter = 9'd0;
				state8_column_counter = 9'd0;
				temp_mem_addr = 8'd0;
				test_mem_addr = 8'd0;
				even_addra =8'd0;
				even_addrb =8'd0;
				odd_addra = 8'd0;
				odd_addrb = 8'd0;
			end
		else
			begin
				case(y)
					initial_state   : begin //State 0
						row_counter = 9'd0;
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;
						temp_mem_addr = 8'd0;
						test_mem_addr = 8'd0;
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 8'd0;
						odd_addrb = 8'd0;
					end

					temp_fill_state : begin //State 1
						row_counter = 9'd0;
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						temp_mem_addr = data_addr;
						test_mem_addr = 8'd0;
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 7'd0;
						odd_addrb = 7'd0;
					end

					test_fill_state : begin //State 2
						row_counter = 9'd0;
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						temp_mem_addr = 8'd0;
						test_mem_addr = data_addr; // State 2
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 7'd0;
						odd_addrb = 7'd0;
					end

					calculate_first_cell : begin //State 3
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						temp_mem_addr = 8'd0;
						test_mem_addr = 8'd0;
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 8'd0;
						odd_addrb = 8'd0;
					end

					calculate_first_row : begin //State 4
						if(clk_counter==4'b1111) state4_column_counter = state4_column_counter + 1'b1;
						else state4_column_counter = state4_column_counter;

						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						if(state4_column_counter==256) row_counter = row_counter + 1'b1;
						else row_counter = row_counter;
						


						temp_mem_addr = state4_column_counter;
						test_mem_addr = 8'd0;
						even_addra = state4_column_counter;
						even_addrb = state4_column_counter - 1'b1;
						odd_addra = 7'd0;
						odd_addrb = 7'd0;

					end

					calculate_odd_first_cell : begin //State 5
						state4_column_counter = state4_column_counter;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						temp_mem_addr = 8'd0;
						test_mem_addr = row_counter;
						//		even_addra = ;                  
						//even_addra = row_counter - 1'b1;
						even_addra = 8'd0;
						odd_addra = 8'd0;
						//      odd_addrb = ?
					end

					calculate_odd_row : begin //State 6
						state8_column_counter = 9'd1;
						state4_column_counter = 9'd0;

						if(clk_counter==4'b1111) state6_column_counter = state6_column_counter + 1'b1;
						else state6_column_counter = state6_column_counter;

						if(state6_column_counter==256) row_counter = row_counter + 1'b1;
						else row_counter = row_counter;


						temp_mem_addr = state6_column_counter;
						test_mem_addr = row_counter;
						even_addra = state6_column_counter;
						even_addrb = state6_column_counter - 1'b1;
						odd_addra = state6_column_counter;
						odd_addrb = state6_column_counter - 1'b1;
					end

					calculate_even_first_cell : begin //State 7
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						state8_column_counter = 9'd1;

						temp_mem_addr = 8'd0;
						test_mem_addr = row_counter;
						even_addra = 8'd0;
						//odd_addra = row_counter - 1'b0;
						odd_addra = 8'd0;
					end

					calculate_even_row : begin //State 8
						state4_column_counter = 9'd1;
						state6_column_counter = 9'd1;
						if(clk_counter==4'b1111) state8_column_counter = state8_column_counter + 1'b1;
						else state8_column_counter = state8_column_counter;

						if(state8_column_counter==256) row_counter = row_counter + 1'b1;
						else row_counter = row_counter;
						


						temp_mem_addr = state8_column_counter;
						test_mem_addr = row_counter;
						even_addra = state8_column_counter;
						even_addrb = state8_column_counter- 1'b1;
						odd_addra = state8_column_counter;
						odd_addrb = state8_column_counter  - 1'b1;
					end
					
				final_state : begin
						state4_column_counter = 9'd0;
						state6_column_counter = 9'd0;
						state8_column_counter = 9'd0;

						temp_mem_addr = 8'd0;
						test_mem_addr = 8'd0;
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 8'd255;
						odd_addrb = 8'd0;
					end
					

					default : begin
						state4_column_counter = 9'd0;
						state6_column_counter = 9'd0;
						state8_column_counter = 9'd0;

						temp_mem_addr = 8'd0;
						test_mem_addr = 8'd0;
						even_addra = 8'd0;
						even_addrb = 8'd0;
						odd_addra = 8'd0;
						odd_addrb = 8'd0;
					end
				endcase
			end
	end

	always @(posedge clk)
	if(rst)
	   clk_counter <= 0;
	else
	begin
        if(en)
            clk_counter <= clk_counter +1;
        else
            clk_counter <= clk_counter;
    end

endmodule