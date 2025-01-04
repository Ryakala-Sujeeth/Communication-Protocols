`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.01.2025 15:10:00
// Design Name: 
// Module Name: tb_i2c_master
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


`timescale 1ns/1ps

module tb_i2c_master;

    
    reg clk;
    reg reset;
    wire scl;
    wire sda;

    
    reg start;
    reg [6:0] master_addr;
    reg rw;
    reg [7:0] master_data_in;
    wire [7:0] master_data_out;
    wire master_ack_error;
    wire [2:0]state;

   
    reg [7:0] slave_data_in;
    wire [7:0] slave_data_out;
    wire[2:0]slave_state;

   
    i2c_master master (
        .clk(clk),
        .reset(reset),
        .start(start),
        .addr(master_addr),
        .rw(rw),
        .data_in(master_data_in),
        .data_out(master_data_out),
        .ack_error(master_ack_error),
        .sda(sda),
        .scl(scl),
        .state(state)
    );


    i2c_slave slave (
        .clk(clk),
        .reset(reset),
        .data_out(slave_data_out),
        .data_in(slave_data_in),
        .sda(sda),
        .scl(scl),
        .state(slave_state)
    );

 
    always #5 clk = ~clk; 

   
    initial begin
        
        clk = 0;
        reset = 1;
        start = 0;
        master_addr = 7'b1010101;
        rw = 0;
        master_data_in = 8'b0;
        slave_data_in = 8'b0;

        
        #20;
        reset = 0;

       
        #10;
        start = 1;
        rw = 0; 
        master_data_in = 8'b00101011;
        #10;
        start = 0;

        #200;
        
        
        #20;
        start = 1;
        rw = 1;
        slave_data_in = 8'b10010011; 
        #10;
        start = 0;

        #200;

     
        $finish;
    end

   
    initial begin
        $monitor($time, " Master -> Addr: %h, Data In: %h, Data Out: %h, Ack Error: %b | Slave -> Data In: %h, Data Out: %h",
                 master_addr, master_data_in, master_data_out, master_ack_error, slave_data_in, slave_data_out);
    end

endmodule





