# Dynamic Time Warphing

Dynamic Time Warphing (DTW) ,  is one of the algorithms for measuring the minimum cost distance between two time series data.  In this project, DTW modules, which is available on [DTW_Implementation](https://github.com/remziorak/DTW_Implementation)  repository , modified as AXI-based IP cores. 

- **DTW_2F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 2 and length of 256. Each dimension represented as 16 bit signed integer.
- **DTW_4F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 4 and length of 256. Each dimension represented as 8 bit signed integer.
- **DTW_8F_32bit :** Computes *DTW(A, B)* where *A* and *B* are dimension of 8 and length of 256. Each dimension represented as 4 bit signed integer.



Zybo Z7-20 ARM/FPGA SoC used as a development board and resource utilization tables for all *DTW* modules are given as following.

![image](https://user-images.githubusercontent.com/45906647/87888737-3639ef80-ca37-11ea-940c-ab30977cf18d.png)



