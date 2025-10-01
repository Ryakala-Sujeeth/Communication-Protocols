module top_spi (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [15:0] master_data_in,
    input wire [15:0] slave_data_in,
    output wire [15:0] master_data_out,
    output wire [15:0] slave_data_out,
    output wire done
);

    wire sclk;
    wire mosi;
    wire miso;
    wire ss;

    Master master (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(master_data_in),
        .sclk(sclk),
        .mosi(mosi),
        .miso(miso),
        .ss(ss),
        .data_out(master_data_out),
        .done(done)
    );

    Slave slave (
        .sclk(sclk),
        .ss(ss),
        .mosi(mosi),
        .miso(miso),
        .data_in(slave_data_in),
        .data_out(slave_data_out)
    );

endmodule