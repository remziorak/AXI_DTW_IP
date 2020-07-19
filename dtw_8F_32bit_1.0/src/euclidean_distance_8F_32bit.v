`timescale 1ns / 1ps

module euclidean_distance_8F_32bit (template_data, test_data, clk, euclidean_out);

	parameter N               = 32; // cell data width for inputs
	parameter M               = 8; // output cell width after square root calculation
	parameter F1_width        = 4; // Feature 1 width
	parameter F2_width        = 4; // Feature 2 width
	parameter F3_width        = 4; // Feature 3 width
	parameter F4_width        = 4; // Feature 4 width
	parameter F5_width        = 4; // Feature 5 width
	parameter F6_width        = 4; // Feature 6 width
	parameter F7_width        = 4; // Feature 7 width
	parameter F8_width        = 4; // Feature 8 width	
	
	parameter F1_msb_index    = N-1; // Most significant bit index for Feature 1 
	parameter F1_lsb_index    = F1_msb_index-F1_width+1; // Least significant bit index for Feature 1 
	parameter F2_msb_index    = F1_lsb_index-1; // Most significant bit index for Feature 2  
	parameter F2_lsb_index    = F2_msb_index-F2_width+1; // Least significant bit index for Feature 2
	parameter F3_msb_index    = F2_lsb_index-1; // Most significant bit index for Feature 3 
	parameter F3_lsb_index    = F3_msb_index-F3_width+1; // Least significant bit index for Feature 3 
	parameter F4_msb_index    = F3_lsb_index-1; // Most significant bit index for Feature 4 
	parameter F4_lsb_index    = F4_msb_index-F4_width+1; // Least significant bit index for Feature 4 
    parameter F5_msb_index    = F4_lsb_index-1; // Most significant bit index for Feature 5  
	parameter F5_lsb_index    = F5_msb_index-F5_width+1; // Least significant bit index for Feature 5
	parameter F6_msb_index    = F5_lsb_index-1; // Most significant bit index for Feature 6 
	parameter F6_lsb_index    = F6_msb_index-F6_width+1; // Least significant bit index for Feature 6 
	parameter F7_msb_index    = F6_lsb_index-1; // Most significant bit index for Feature 7 
	parameter F7_lsb_index    = F7_msb_index-F7_width+1; // Least significant bit index for Feature 7 
	parameter F8_msb_index    = F7_lsb_index-1; // Most significant bit index for Feature 8
	parameter F8_lsb_index    = F8_msb_index-F8_width+1; // Least significant bit index for Feature 8	
	
	input   wire    [N-1:0]   template_data;
	input   wire    [N-1:0]   test_data;
	input                     clk;
	output          [M-1:0]   euclidean_out;
    
    reg signed [F1_width-1:0] temp_F1;
    reg signed [F2_width-1:0] temp_F2;
    reg signed [F3_width-1:0] temp_F3;
    reg signed [F4_width-1:0] temp_F4;
    reg signed [F5_width-1:0] temp_F5;
    reg signed [F6_width-1:0] temp_F6;
    reg signed [F7_width-1:0] temp_F7;
    reg signed [F8_width-1:0] temp_F8;    
    
    reg signed [F1_width-1:0] test_F1;
    reg signed [F2_width-1:0] test_F2;
    reg signed [F3_width-1:0] test_F3;
    reg signed [F4_width-1:0] test_F4;
    reg signed [F5_width-1:0] test_F5;
    reg signed [F6_width-1:0] test_F6;
    reg signed [F7_width-1:0] test_F7;
    reg signed [F8_width-1:0] test_F8;   
    
    always @(*)
    begin
        temp_F1 = template_data[F1_msb_index:F1_lsb_index];
        temp_F2 = template_data[F2_msb_index:F2_lsb_index];
        temp_F3 = template_data[F3_msb_index:F3_lsb_index];
        temp_F4 = template_data[F4_msb_index:F4_lsb_index];
        temp_F5 = template_data[F5_msb_index:F5_lsb_index];
        temp_F6 = template_data[F6_msb_index:F6_lsb_index];
        temp_F7 = template_data[F7_msb_index:F7_lsb_index];
        temp_F8 = template_data[F8_msb_index:F8_lsb_index];            
        test_F1 = test_data[F1_msb_index:F1_lsb_index];
        test_F2 = test_data[F2_msb_index:F2_lsb_index];
        test_F3 = test_data[F3_msb_index:F3_lsb_index];
        test_F4 = test_data[F4_msb_index:F4_lsb_index];
        test_F5 = test_data[F5_msb_index:F5_lsb_index];
        test_F6 = test_data[F6_msb_index:F6_lsb_index];
        test_F7 = test_data[F7_msb_index:F7_lsb_index];
        test_F8 = test_data[F8_msb_index:F8_lsb_index];
    end

    
	wire signed [2*F1_width - 1:0] inner_product_F1;
	wire signed [2*F2_width - 1:0] inner_product_F2;
	wire signed [2*F3_width - 1:0] inner_product_F3;
	wire signed [2*F4_width - 1:0] inner_product_F4;
	wire signed [2*F5_width - 1:0] inner_product_F5;
	wire signed [2*F6_width - 1:0] inner_product_F6;
	wire signed [2*F7_width - 1:0] inner_product_F7;
	wire signed [2*F8_width - 1:0] inner_product_F8;	
	
	wire [8:0] sum1;
	wire [8:0] sum2;
    wire [8:0] sum3;
	wire [8:0] sum4;
	wire [9:0] sum5;
	wire [9:0] sum6;
	wire [15:0] total_inner_product; //16 bit giriþ 
	wire tvalid;

	// There is four feature vector concatinated in template and test input vector
	// cordic0 instance calculate the square root of feature euclidean distances summation
	cordic_0 inst1 (.s_axis_cartesian_tvalid(1'b1),
		.s_axis_cartesian_tdata(total_inner_product),
		.m_axis_dout_tvalid(tvalid),
		.m_axis_dout_tdata(euclidean_out)
	);


	assign sum1 = inner_product_F1 + inner_product_F2;
	assign sum2 = inner_product_F3 + inner_product_F4;
	assign sum3 = inner_product_F5 + inner_product_F6;
	assign sum4 = inner_product_F7 + inner_product_F8;
	assign sum5 = sum1 + sum2;
	assign sum6 = sum3 + sum4;
	assign total_inner_product = sum5 + sum6;


/*********************************************************/
//  DSPs make calculations for inner of square root          
xbip_dsp48_macro_0 dsp_inst1(   .CLK(clk),
                                .A(temp_F1 - test_F1),
                                .B(temp_F1 - test_F1),
                                .P(inner_product_F1)
);

xbip_dsp48_macro_0 dsp_inst2(   .CLK(clk),
                                .A(temp_F2 - test_F2),
                                .B(temp_F2 - test_F2),
                                .P(inner_product_F2)
);

xbip_dsp48_macro_0 dsp_inst3(   .CLK(clk),
                                .A(temp_F3 - test_F3),
                                .B(temp_F3 - test_F3),
                                .P(inner_product_F3)
);

xbip_dsp48_macro_0 dsp_inst4(   .CLK(clk),
                                .A(temp_F4 - test_F4),
                                .B(temp_F4 - test_F4),
                                .P(inner_product_F4)
);

xbip_dsp48_macro_0 dsp_inst5(   .CLK(clk),
                                .A(temp_F5 - test_F5),
                                .B(temp_F5 - test_F5),
                                .P(inner_product_F5)
);

xbip_dsp48_macro_0 dsp_inst6(   .CLK(clk),
                                .A(temp_F6 - test_F6),
                                .B(temp_F6 - test_F6),
                                .P(inner_product_F6)
);

xbip_dsp48_macro_0 dsp_inst7(   .CLK(clk),
                                .A(temp_F7 - test_F7),
                                .B(temp_F7 - test_F7),
                                .P(inner_product_F7)
);

xbip_dsp48_macro_0 dsp_inst8(   .CLK(clk),
                                .A(temp_F8 - test_F8),
                                .B(temp_F8 - test_F8),
                                .P(inner_product_F8)
);


endmodule
