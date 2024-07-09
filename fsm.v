`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2024 23:20:23
// Design Name: 
// Module Name: FSM
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


module FSM(
    input [0:7]data,
    input start,
    input clk,
    output reg tx_out=1
    );parameter idle=2'b00,data_load=2'b01,data_shift=2'b10;
    reg [1:0]ps=idle;reg[10:0]tmp;reg parity;integer bit_cout=1;
    
   
    
    always@(posedge  clk)
    begin
  
    
    if(ps==idle)
    
    begin
    ps<=data_load;
    parity<=data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7];
    end
    
    else
    ps<=idle;
    
    
    if(ps==data_load)
    begin
    tmp<={1'b0,data,parity,1'b1};
    
    ps<=data_shift;
   
    bit_cout=1;
    end
    if(ps==data_shift)
    begin
    if(bit_cout!=11)
    begin
    tx_out<=tmp[10];
    tmp<=tmp<<1;
    bit_cout=bit_cout+1;
    ps<=data_shift;

    end
    else
    begin
    ps<=idle;
    bit_cout=0;
    tx_out<=1'b1;
    end
    end
    end
    
    
endmodule
