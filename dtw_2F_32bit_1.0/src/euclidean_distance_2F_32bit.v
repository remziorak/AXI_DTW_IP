`timescale 1ns / 1ps

module euclidean_distance_2F_32bit (template_data, test_data, clk, euclidean_out);

	parameter N               = 32; // cell data width for inputs
	parameter M               = 24; // output cell width after square root calculation
	parameter F1_width        = 16; // Feature 1 width
	parameter F2_width        = 16; // Feature 2 width
	parameter F1_msb_index    = N-1; // Most significant bit index for Feature 1 
	parameter F1_lsb_index    = F1_msb_index-F1_width+1; // Least significant bit index for Feature 1 
	parameter F2_msb_index    = F1_lsb_index-1; // Most significant bit index for Feature 2  
	parameter F2_lsb_index    = F2_msb_index-F2_width+1; // Least significant bit index for Feature 2

	
	input   wire    [N-1:0]   template_data;
	input   wire    [N-1:0]   test_data;
	input                     clk;
	output          [M-1:0]   euclidean_out;
    
    reg signed [F1_width - 1:0] temp_F1;
    reg signed [F2_width - 1:0] temp_F2;
    reg signed [F1_width - 1:0] test_F1;
    reg signed [F2_width - 1:0] test_F2;

    
    
    always @(*)
    begin
        temp_F1 = template_data[F1_msb_index:F1_lsb_index];
        temp_F2 = template_data[F2_msb_index:F2_lsb_index];
        test_F1 = test_data[F1_msb_index:F1_lsb_index];
        test_F2 = test_data[F2_msb_index:F2_lsb_index];

    end

    wire signed [F1_width:0] sub_1 ;
    wire signed [F2_width:0] sub_2 ;

    
    
	wire signed [2*F1_width + 1:0] inner_product_F1;
	wire signed [2*F2_width + 1:0] inner_product_F2;


	wire [39:0] total_inner_product; //34 bit giris
	wire tvalid;

	// There is four feature vector concatinated in template and test input vector
	// cordic0 instance calculate the square root of feature euclidean distances summation
	cordic_0 inst1 (.s_axis_cartesian_tvalid(1'b1),
		.s_axis_cartesian_tdata(total_inner_product),
		.m_axis_dout_tvalid(tvalid),
		.m_axis_dout_tdata(euclidean_out)
	);
 
 
    assign sub_1 = temp_F1 - test_F1;
    assign sub_2 = temp_F2 - test_F2;



	assign total_inner_product = inner_product_F1 + inner_product_F2;


/*********************************************************/
//  DSPs make calculations for inner of square root          
xbip_dsp48_macro_0 dsp_inst1(   .CLK(clk),
                                .A(sub_1),
                                .B(sub_1),
                                .P(inner_product_F1)
);

xbip_dsp48_macro_0 dsp_inst2(   .CLK(clk),
                                .A(sub_2),
                                .B(sub_2),
                                .P(inner_product_F2)
);




endmodule
