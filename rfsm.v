`timescale 1ns / 1ps
module rfsm(
    input clk,       // System clock
    input rx,            // UART input signal
    output reg [7:0] data_out, // Output data
    output reg rx_ready       // Ready signal indicating data is valid
);

// Internal states

parameter START = 2'b01;
parameter DATA = 2'b10;
parameter PARITY = 2'b11;
parameter STOP=3'b100;
reg [2:0] state;
reg [8:0] shift_reg;
reg [3:0] bit_count;
reg parity; // Parity bit

// Initialize
initial begin
    state <= START;
    shift_reg <= 8'h00;
    bit_count <= 4'd1;
    rx_ready <= 1'b1;
    parity<=1'b0;
    data_out<=1'b0;
end

// State machine
always @(posedge clk)
begin
    case (state) 
    
        START: begin
            if (!rx)
                state <= DATA;
                rx_ready<=0;
        end
        DATA: begin
            if (bit_count < 4'd8)
            begin
                shift_reg[0] = rx;
                shift_reg=shift_reg<<1;
                bit_count <= bit_count + 4'd1;
                parity<=rx^parity;
            end
            else
            begin
                state <= PARITY;
                bit_count<=4'd1;
                
            end
                
        end
        PARITY: begin
            if (rx == parity)
            begin
            data_out = shift_reg;
                state <= STOP;
                
                
            end
            else
                state <= START; // Restart if parity check fails
        end
        STOP: begin
        if(rx==1'b1)
        begin
        rx_ready<=1'b1;
        state<=START;
        end
        end
    endcase
end

endmodule
