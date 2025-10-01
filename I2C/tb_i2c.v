module tb_i2c;

    reg clk;
    reg reset;
    reg start;
    reg [6:0] master_addr;
    reg rw;
    reg [7:0] master_data_in;
    wire [7:0] master_data_out;
    wire master_ack_error;
    reg [7:0] slave_data_in;
    wire [7:0] slave_data_out;

    top_i2c top_module (
        .clk(clk),
        .reset(reset),
        .start(start),
        .master_addr(master_addr),
        .rw(rw),
        .master_data_in(master_data_in),
        .master_data_out(master_data_out),
        .master_ack_error(master_ack_error),
        .slave_data_in(slave_data_in),
        .slave_data_out(slave_data_out)
    );

    always #5 clk = ~clk;

    initial begin
        // 1. Initial Reset
        $display("Applying reset...");
        clk = 0;
        reset = 1;
        start = 0;
        master_addr = 7'b1010101;
        rw = 0;
        master_data_in = 8'h00;
        slave_data_in = 8'h00;

        // 2. Release Reset
        #20;
        reset = 0;
        $display("Reset released.");
        #10;

        // 3. Master Write Transaction
        $display("Starting Master Write transaction...");
        start = 1;
        rw = 0;
        master_data_in = 8'h2B; // Arbitrary data to write
        #10;
        start = 0;

        // 4. Wait for transaction to complete
        // A simple delay is used here, a more robust check would wait on a state change
        #200;
        $display("Master Write transaction complete.");
        $display("Master Data In: %h", master_data_in);
        $display("Slave Data Out: %h", slave_data_out);

        // 5. Master Read Transaction
        $display("Starting Master Read transaction...");
        start = 1;
        rw = 1;
        slave_data_in = 8'h93; // Arbitrary data to be read by the master
        #10;
        start = 0;

        // 6. Wait for transaction to complete
        #200;
        $display("Master Read transaction complete.");
        $display("Slave Data In: %h", slave_data_in);
        $display("Master Data Out: %h", master_data_out);

        // 7. End Simulation
        #20;
        $finish;
    end

    // Monitor
    initial begin
        $monitor($time, " | Master Addr: %h, Master Data In: %h, Master Data Out: %h, Ack Error: %b | Slave Data In: %h, Slave Data Out: %h",
                 master_addr, master_data_in, master_data_out, master_ack_error, slave_data_in, slave_data_out);
    end

endmodule