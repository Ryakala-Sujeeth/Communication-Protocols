`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.01.2024 21:08:07
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen(
    input clk,
    output reg baud_clk
    );integer count=1;
    initial
    begin
    baud_clk<=1;
    end
    always@(posedge clk)
    begin
    if(count==5158)
    begin
    baud_clk=~baud_clk;
    count=1;
    end
    else
    begin
    count<=count+1;
    end
    end
endmodule


