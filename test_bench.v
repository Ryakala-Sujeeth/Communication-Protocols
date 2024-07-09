`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.03.2024 00:36:23
// Design Name: 
// Module Name: test_bench
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


module test_bench();
reg [7:0]data;
reg rx;
reg start,clk;
wire [7:0]data_out;
wire rx_ready;
wire tx_out;
top_module C(.data(data),.start(start),.clk(clk),.tx_out(tx_out),.rx(rx),.data_out(data_out),.rx_ready(rx_ready));
always
begin
#5 clk=~clk;
end
initial
begin
start=1'b1;
clk=1'b1;
data=8'hae;
#2291740;
rx=1'b1;
#103160;
rx=1'b0;
#103160;
rx=1'b1;
#103160;
rx=1'b0;
#103160;
rx=1'b1;
#103160;
rx=1'b0;
#103160;
rx=1'b1;
#103160;
rx=1'b1;
#103160;
rx=1'b1;
#103160;
rx=1'b0;
#103160;
rx=1'b1;
#103160;
rx=1'b1;
#103160;
$finish;
#103160;
end
endmodule
