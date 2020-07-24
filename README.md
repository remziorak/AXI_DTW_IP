# Dynamic Time Warphing

Dynamic Time Warphing (DTW) ,  is one of the algorithms for measuring the minimum cost distance between two time series data.  In this project, DTW modules, which is available on [DTW_Implementation](https://github.com/remziorak/DTW_Implementation)  repository , modified as AXI-based IP cores. 

- **DTW_2F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 2 and length of 256. Each dimension represented as 16 bit signed integer.
- **DTW_4F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 4 and length of 256. Each dimension represented as 8 bit signed integer.
- **DTW_8F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 8 and length of 256. Each dimension represented as 4 bit signed integer.


Example RTL schematic given as following.

![image](https://user-images.githubusercontent.com/45906647/88442272-8ab8e280-ce1c-11ea-9f95-ed9261800a4b.png)

The IO ports shown in RTL schematic mapped on 6 register. This registers are read and written by processor through AXI Interconnect. Register mapping shown in below table.

| Register | Port Name     | Description                                                  |
| -------- | ------------- | ------------------------------------------------------------ |
| reg0     | data_in       | Input data to write the memory                               |
| reg1     | data_addr     | Define the memory address to write the input data            |
| reg2     | sys_status    | Define the system status. <br />0 - IDLE <br />1 - TEMPLATE : Write the input data to the template memory<br />2 - TEST : Write the input data to the test memory<br />3 - COMP: Memories are ready. Compute the DTW value |
| reg3[0]  | en            | To enable the system                                         |
| reg3[1]  | rst           | To reset the system (Active High)                            |
| reg4     | dtw_out       | Output of the DTW                                            |
| reg5     | dtw_state_out | To check the finish sign. When state value is b'1001 output of the DTW are ready. |



Zybo Z7-20 ARM/FPGA SoC used as a development board and resource utilization tables for all *DTW* modules are given as following.

![image](https://user-images.githubusercontent.com/45906647/87888737-3639ef80-ca37-11ea-940c-ab30977cf18d.png)



