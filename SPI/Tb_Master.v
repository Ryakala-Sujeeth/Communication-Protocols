module tb_spi;

    reg clk;                   // System clock for master
    reg rst;                   // Reset signal for master
    reg start;                 // Start signal for master
    reg [15:0] master_data_in; // Data to be sent by master
    reg [15:0] slave_data_in;  // Data to be sent by slave
    wire sclk;                 // SPI clock
    wire mosi;                 // Master Out Slave In
    wire miso;                 // Master In Slave Out
    wire ss;                   // Slave Select
    wire [15:0] master_data_out; // Data received by master
    wire [15:0] slave_data_out;  // Data received by slave
    wire done;                 // Transmission complete flag

    // Instantiate SPI Master
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

    // Instantiate SPI Slave
    Slave slave (
        .sclk(sclk),
        .ss(ss),
        .mosi(mosi),
        .miso(miso),
        .data_in(slave_data_in),
        .data_out(slave_data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with 10 ns period
    end

    // Testbench sequence
    initial begin
        // Initialize signals
        rst = 1;
        start = 0;
        master_data_in = 16'hA5A5; // Data to send from master
        slave_data_in = 16'h5A5A;  // Data to send from slave

        #20 rst = 0;               // Release reset
        #20 start = 1;             // Start SPI transmission
        #1000 start = 0;             // Deactivate start

        wait(done);                // Wait for master to complete transmission
        #20;

        // Display results
        $display("Master sent: %h", master_data_in);
        $display("Slave received: %h", slave_data_out);
        $display("Slave sent: %h", slave_data_in);
        $display("Master received: %h", master_data_out);

        $stop;
    end

endmodule
