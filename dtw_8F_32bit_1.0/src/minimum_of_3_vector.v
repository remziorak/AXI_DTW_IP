module minimum_of_3_vector( vector1, vector2, vector3, out );

	parameter N = 32; //vector width

	input   [N-1:0] vector1;
	input   [N-1:0] vector2;
	input   [N-1:0] vector3;
	output  [N-1:0] out;
    
    wire [N-1:0] z;  // result of comparison between vector1 and vector2
    
    assign z = (vector1<vector2) ? vector1 : vector2;
    assign out = (z<vector3) ? z : vector3;


endmodule
