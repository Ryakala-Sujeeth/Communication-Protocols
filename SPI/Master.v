`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2024 16:56:45
// Design Name: 
// Module Name: Master
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


module Master (
    input wire clk,             
    input wire rst,             
    input wire start,           
    input wire [15:0] data_in,  
    output reg sclk,            
    output reg mosi,            
    input wire miso,            
    output reg ss,              
    output reg [15:0] data_out, 
    output reg done             
);

    reg [4:0] bit_cnt;          
    reg [16:0] shift_reg;       
    reg [15:0] rx_reg;         
    reg [7:0] clk_div;          

    parameter DIVIDER = 8'd1;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sclk <= 0;
            mosi <= 0;
            ss <= 1;  
            done <= 0;
            bit_cnt <= 0;
            shift_reg<=data_in;
            rx_reg <= 0;
            clk_div <= 0;
        end else begin
            if (start && !done) begin
                ss <= 0;  
                
                if (clk_div == DIVIDER) begin
                    sclk <= ~sclk;  
                    clk_div <= 0;

                    if (sclk == 0) begin
                        
                        mosi <= shift_reg[16];
                        shift_reg <= {shift_reg[15:0], 1'b0};
                    end else begin
                        rx_reg <= {rx_reg[14:0], miso};
                        bit_cnt <= bit_cnt + 1;
                        if (bit_cnt == 16) begin
                            done <= 1;
                            ss <= 1;  
                            data_out <= rx_reg;
                        end
                    end
                end else begin
                    clk_div <= clk_div + 1;
                end
            end else if (done) begin
                done <= 0;  
            end
        end
    end
endmodule

