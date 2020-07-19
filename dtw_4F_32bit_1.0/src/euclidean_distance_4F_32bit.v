`timescale 1ns / 1ps

module euclidean_distance_4F_32bit (template_data, test_data, clk, euclidean_out);

	parameter N               = 32; // cell data width for inputs
	parameter M               = 16; // output cell width after square root calculation
	parameter F1_width        = 8; // Feature 1 width
	parameter F2_width        = 8; // Feature 2 width
	parameter F3_width        = 8; // Feature 3 width
	parameter F4_width        = 8; // Feature 4 width
	parameter F1_msb_index    = N-1; // Most significant bit index for Feature 1 
	parameter F1_lsb_index    = F1_msb_index-F1_width+1; // Least significant bit index for Feature 1 
	parameter F2_msb_index    = F1_lsb_index-1; // Most significant bit index for Feature 2  
	parameter F2_lsb_index    = F2_msb_index-F2_width+1; // Least significant bit index for Feature 2
	parameter F3_msb_index    = F2_lsb_index-1; // Most significant bit index for Feature 3 
	parameter F3_lsb_index    = F3_msb_index-F3_width+1; // Least significant bit index for Feature 3 
	parameter F4_msb_index    = F3_lsb_index-1; // Most significant bit index for Feature 4 
	parameter F4_lsb_index    = F4_msb_index-F4_width+1; // Least significant bit index for Feature 4 
	
	input   wire    [N-1:0]   template_data;
	input   wire    [N-1:0]   test_data;
	input                     clk;
	output          [M-1:0]   euclidean_out;
    
    reg signed [F1_width-1:0] temp_F1;
    reg signed [F2_width-1:0] temp_F2;
    reg signed [F3_width-1:0] temp_F3;
    reg signed [F4_width-1:0] temp_F4;
    reg signed [F1_width-1:0] test_F1;
    reg signed [F2_width-1:0] test_F2;
    reg signed [F3_width-1:0] test_F3;
    reg signed [F4_width-1:0] test_F4;
    
    
    always @(*)
    begin
        temp_F1 = template_data[F1_msb_index:F1_lsb_index];
        temp_F2 = template_data[F2_msb_index:F2_lsb_index];
        temp_F3 = template_data[F3_msb_index:F3_lsb_index];
        temp_F4 = template_data[F4_msb_index:F4_lsb_index];
        test_F1 = test_data[F1_msb_index:F1_lsb_index];
        test_F2 = test_data[F2_msb_index:F2_lsb_index];
        test_F3 = test_data[F3_msb_index:F3_lsb_index];
        test_F4 = test_data[F4_msb_index:F4_lsb_index];
    end

wire signed [F1_width:0] sub_1 ;
wire signed [F2_width:0] sub_2 ;
wire signed [F3_width:0] sub_3 ;
wire signed [F4_width:0] sub_4 ;

    
	wire signed [2*F1_width + 1:0] inner_product_F1;
	wire signed [2*F2_width + 1:0] inner_product_F2;
	wire signed [2*F3_width + 1:0] inner_product_F3;
	wire signed [2*F4_width + 1:0] inner_product_F4;
	wire signed [18:0] sum1;
	wire signed [18:0] sum2;
	wire [23:0] total_inner_product; //24 bit giriþ 
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
    assign sub_3 = temp_F3 - test_F3;
    assign sub_4 = temp_F4 - test_F4;



	assign sum1 = inner_product_F1 + inner_product_F2;
	assign sum2 = inner_product_F3 + inner_product_F4;
	assign total_inner_product = sum1 + sum2;




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

xbip_dsp48_macro_0 dsp_inst3(   .CLK(clk),
                                .A(sub_3),
                                .B(sub_3),
                                .P(inner_product_F3)
);

xbip_dsp48_macro_0 dsp_inst4(   .CLK(clk),
                                .A(sub_4),
                                .B(sub_4),
                                .P(inner_product_F4)
);


endmodule
