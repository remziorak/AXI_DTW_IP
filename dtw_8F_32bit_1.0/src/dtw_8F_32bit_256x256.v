`timescale 1ns / 1ps

module dtw_8F_32bit_256x256(data_in, data_addr, sys_status, en, clk, rst, dtw_state_out, dtw_out);

input [31:0]    data_in;
input [7:0]     data_addr;
input [1:0]     sys_status;
input           en;
input           clk;
input           rst;
output [3:0]    dtw_state_out;
output [31:0]   dtw_out;

wire even_mem_write_enable;
wire odd_mem_write_enable;
wire temp_mem_write_enable;
wire test_mem_write_enable;

wire [3:0] dtw_state;

wire [7:0] even_addra ;
wire [7:0] even_addrb ;
wire [7:0] odd_addra ;
wire [7:0] odd_addrb ;
wire [7:0] temp_mem_addr ;
wire [7:0] test_mem_addr ;

wire [31:0] temp_memory_out;
wire [31:0] test_memory_out;

wire [7:0] euclidean_out;

wire [31:0] even_douta;
wire [31:0] even_doutb;
wire [31:0] odd_douta;
wire [31:0] odd_doutb;
wire [31:0] dtw_cell_out;


(* dont_touch = "true" *) memory_controller memory_controller_inst (
// Input Ports - Single Bit
.clk                   (clk),
.en                    (en),
.rst                   (rst),
// Input Ports - Busses
.sys_status                  (sys_status),
.data_addr                   (data_addr),
// Output Ports - Single Bit
.even_mem_write_enable (even_mem_write_enable),
.odd_mem_write_enable  (odd_mem_write_enable),
.temp_mem_write_enable (temp_mem_write_enable),
.test_mem_write_enable (test_mem_write_enable),
// Output Ports - Busses
.dtw_state      (dtw_state[3:0]),
.even_addra       (even_addra[7:0]),
.even_addrb       (even_addrb[7:0]),
.odd_addra        (odd_addra[7:0]),
.odd_addrb        (odd_addrb[7:0]),
.temp_mem_addr    (temp_mem_addr[7:0]),
.test_mem_addr    (test_mem_addr[7:0])
// InOut Ports - Single Bit
// InOut Ports - Busses
);

temp_test_memory temp_test_memory_inst (
// Input Ports - Single Bit
.clk                   (clk),
//   .rst                   (rst),
.temp_mem_write_enable (temp_mem_write_enable),
.test_mem_write_enable (test_mem_write_enable),
// Input Ports - Busses
.temp_mem_addr    (temp_mem_addr[7:0]),
.template_data    (data_in[31:0]),
.test_data        (data_in[31:0]),
.test_mem_addr    (test_mem_addr[7:0]),
// Output Ports - Busses
.temp_memory_out (temp_memory_out[31:0]),
.test_memory_out (test_memory_out[31:0])
);



dtw_matrix_memory dtw_matrix_memory_inst (
// Input Ports - Single Bit
.clk                   (clk),
.even_mem_write_enable (even_mem_write_enable),
.odd_mem_write_enable  (odd_mem_write_enable),
// .rst                   (rst),
// Input Ports - Busses
.data_in          (dtw_cell_out[31:0]),
.even_addra       (even_addra[7:0]),
.even_addrb       (even_addrb[7:0]),
.odd_addra        (odd_addra[7:0]),
.odd_addrb        (odd_addrb[7:0]),
// Output Ports - Busses
.even_douta      (even_douta[31:0]),
.even_doutb      (even_doutb[31:0]),
.odd_douta       (odd_douta[31:0]),
.odd_doutb       (odd_doutb[31:0])
// InOut Ports - Single Bit
// InOut Ports - Busses
);


dtw_value_comp dtw_value_comp_inst (
// Input Ports - Single Bit
.clk                (clk),
.en                 (en),
.rst                (rst),
// Input Ports - Busses
.distance     (euclidean_out),
.even_douta   (even_douta),
.even_doutb   (even_doutb),
.odd_douta    (odd_douta),
.odd_doutb    (odd_doutb),
.states       (dtw_state),
// Output Ports - Single Bit
// Output Ports - Busses
.dtw_cell_out (dtw_cell_out[31:0])
// InOut Ports - Single Bit
// InOut Ports - Busses
);


euclidean_distance_8F_32bit euclidean_distance_inst (.template_data(temp_memory_out[31:0]),
.test_data(test_memory_out[31:0]),
.clk(clk),
.euclidean_out(euclidean_out));

assign dtw_state_out = dtw_state;
//assign dtw_out = (dtw_state == 4'b1001) ? odd_douta : 0;
assign dtw_out = (dtw_state == 4'b1001) ? odd_douta : odd_douta;

endmodule
