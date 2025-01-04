`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2025 15:01:36
// Design Name: 
// Module Name: i2c_master
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


module i2c_master (
    input wire clk,          
    input wire reset,       
    input wire start,        
    input wire [6:0] addr,   
    input wire rw,           
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg ack_error,    
    inout wire sda,          
    output reg scl  ,    output state         
);

    // State Machine States
    
     reg [3:0]IDLE =3'b000;
     reg [3:0]START=3'b001;
     reg [3:0]ADDR=3'b010;
     reg [3:0]ACK_CHECK=3'b011;
     reg [3:0]DATA=3'b100;
     reg [3:0]STOP=3'b101;
    
    reg[3:0] state, next_state;

    reg [3:0] bit_counter;  
    reg sda_out;           
    reg scl_en;             
    reg sda_dir;            

  
    assign sda = sda_dir ? sda_out : 1'bz; 

   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scl <= 1;
            sda_out <= 1;
            sda_dir <= 1;
            ack_error <= 0;
            bit_counter<=0;
        end else begin
            if (scl_en) scl <= ~scl;
            else scl<=1'b1; 
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            if (state == ADDR || state == DATA) bit_counter <= bit_counter + 1;
            else bit_counter <= 0;
        end
    end

    
    always @(*) begin
        next_state = state;
        sda_out = 1;
        sda_dir = 1;
        scl_en = 0;
        ack_error = 0;

        case (state)
            IDLE: begin
                if (start) next_state = START;
            end

            START: begin
                sda_out = 0;  
                scl_en = 1;
                next_state = ADDR;
            end

            ADDR: begin
                scl_en = 1;
                if (bit_counter < 7) sda_out = addr[6 - bit_counter];
                else if (bit_counter == 7) sda_out = rw;
                else begin
                    sda_dir = 0;
                    next_state = ACK_CHECK;
                end
            end

            ACK_CHECK: begin
                scl_en = 1;
                if (!scl) begin
                    if (sda) begin 
                    ack_error = 1; 
                    next_state = IDLE;
                    end
                    else
                    next_state = DATA;
                end
            end

            DATA: begin
                scl_en = 1;
                if (!rw) begin
                    sda_dir = 1; 
                    if (bit_counter < 8) sda_out = data_in[7 - bit_counter];
                    else begin
                        
                        sda_dir = 0; 
                        next_state = STOP;
                       
                    end
                end else begin
                    sda_dir = 0; 
                    if (bit_counter < 8) data_out[7 - bit_counter] = sda;
                    else 
                    begin
                    next_state = STOP;
                    
                    end
                end
            end

            STOP: begin
                sda_dir<=1'b1;
                sda_out = 1'b1;  
                scl_en = 1'b0;
                next_state = IDLE;
            end
        endcase
    end
endmodule

