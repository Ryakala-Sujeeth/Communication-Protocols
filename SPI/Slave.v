`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 19:18:53
// Design Name: 
// Module Name: Slave
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


module Slave (
    input wire sclk,            
    input wire ss,           
    input wire mosi,          
    output reg miso,           
    input wire [15:0] data_in, 
    output reg [15:0] data_out  
);

    reg [3:0] bit_cnt;          
    reg [15:0] shift_reg;      
    reg [15:0] shift_reg2;
    always @(posedge sclk or posedge ss) begin
        if (ss) begin
            bit_cnt <= 0; 
            miso<=0;     
            shift_reg <= data_in;
            data_out<=shift_reg2;
        end else begin
            
            shift_reg2 <= {shift_reg2[14:0], mosi};
            
            miso <= shift_reg[15];
            shift_reg <= {shift_reg[14:0], 1'b0};
            bit_cnt <= bit_cnt + 1;
        end
    end
endmodule
