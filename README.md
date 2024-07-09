This Project contains my work on the communication protocol UART(Universal Asynchronous Receiver and Transmitter)
Here I can send 8 bit of data serially and receive 8 bit of data using this protocol 
The bit stream generated and recieved bit stream is in format of one start bit(Taken as 0) ,The 8 bits of data ,One Odd Parity bit and one stop bit(1).
The coding is Done Verilog and the model is simulatedly verified by using Xilinx Vivado.
The image of the simulation result is also shared where first the transmission of the data given occurs and after a few clock cycles (after my tranmission is done) the receiving is done.
