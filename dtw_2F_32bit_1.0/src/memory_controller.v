`timescale 1ns / 1ps

module memory_controller(en, clk, rst, sys_status, data_addr, dtw_state, temp_mem_addr, test_mem_addr, even_addra, even_addrb,  odd_addra, odd_addrb,
temp_mem_write_enable,test_mem_write_enable, odd_mem_write_enable, even_mem_write_enable);

input wire  en;
input wire  clk;
input wire  rst;
input       [1:0]   sys_status;
input       [7:0]   data_addr;
output      [3:0]   dtw_state;
output      [7:0]   temp_mem_addr;
output      [7:0]   test_mem_addr;
output      [7:0]   even_addra;
output      [7:0]   even_addrb;
output      [7:0]   odd_addra;
output      [7:0]   odd_addrb;
output              temp_mem_write_enable;
output              test_mem_write_enable;
output              odd_mem_write_enable;
output              even_mem_write_enable;

wire        [3:0]   dtw_state;

memory_address_generator memory_address_generator_inst (
// Input Ports - Single Bit
.clk                   (clk),
.en                    (en),
.rst                   (rst),
// Input Ports - Busses
.sys_status            (sys_status),
.data_addr             (data_addr),
// Output Ports - Single Bit
// Output Ports - Busses
.dtw_state        (dtw_state[3:0]),
.even_addra       (even_addra[7:0]),
.even_addrb       (even_addrb[7:0]),
.odd_addra        (odd_addra[7:0]),
.odd_addrb        (odd_addrb[7:0]),
.temp_mem_addr    (temp_mem_addr[7:0]),
.test_mem_addr    (test_mem_addr[7:0])
);


memory_en_controller memory_en_controller_inst (
// Input Ports - Single Bit
.rst                   (rst),
// Input Ports - Busses
.dtw_state            (dtw_state[3:0]),
// Output Ports - Single Bit
.even_mem_write_enable (even_mem_write_enable),
.odd_mem_write_enable  (odd_mem_write_enable),
.temp_mem_write_enable (temp_mem_write_enable),
.test_mem_write_enable (test_mem_write_enable)
);

endmodule

