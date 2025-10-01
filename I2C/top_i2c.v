module top_i2c (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [6:0] master_addr,
    input wire rw,
    input wire [7:0] master_data_in,
    output wire [7:0] master_data_out,
    output wire master_ack_error,
    input wire [7:0] slave_data_in,
    output wire [7:0] slave_data_out
);

    wire scl;
    wire sda;
    wire [2:0] master_state;
    wire [2:0] slave_state;

    // Instantiate I2C Master
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
        .state(master_state)
    );

    // Instantiate I2C Slave
    i2c_slave slave (
        .clk(clk),
        .reset(reset),
        .data_out(slave_data_out),
        .data_in(slave_data_in),
        .sda(sda),
        .scl(scl),
        .state(slave_state)
    );

endmodule