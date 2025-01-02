`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.05.2024 11:07:24
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(input [7:0] data,
input start,
input clk,
input rx,
output[7:0] data_out,
output rx_ready,
output tx_out
 
    );wire baud_clk;
    baud_rate_gen A(.clk(clk),.baud_clk(baud_clk));
    FSM C(.data(data),.start(start),.clk(baud_clk),.tx_out(tx_out));
    rfsm D(.data_out(data_out),.clk(baud_clk),.rx(rx),.rx_ready(rx_ready));
endmodule
