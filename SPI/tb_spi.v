module tb_spi;

    
    parameter CLK_PERIOD = 10;

    
    reg clk;                    
    reg rst;                    
    reg start;                  
    reg [15:0] master_data_in;  
    reg [15:0] slave_data_in;   
    wire [15:0] master_data_out;
    wire [15:0] slave_data_out;  
    wire done;                  

    top_spi top_module (
        .clk(clk),
        .rst(rst),
        .start(start),
        .master_data_in(master_data_in),
        .slave_data_in(slave_data_in),
        .master_data_out(master_data_out),
        .slave_data_out(slave_data_out),
        .done(done)
    );

    
    initial begin
        clk = 0;
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

    
    initial begin
        // 1. Initial Reset
        $display("Applying reset...");
        rst = 1;
        start = 0;
        master_data_in = 16'hA5A5; [cite_start]
        slave_data_in = 16'h5A5A;  [cite_start]

        // 2. Release Reset
        # (2 * CLK_PERIOD) rst = 0; [cite_start]
        $display("Reset released.");
        # (2 * CLK_PERIOD);

        // 3. Start Transmission
        $display("Starting SPI transmission...");
        start = 1; [cite_start]
        wait(done); [cite_start]

    
        # (CLK_PERIOD);
        start = 0; [cite_start]
        $display("Transmission complete.");
        [cite_start]$display("Master sent: %h", master_data_in); [cite: 37]
        [cite_start]$display("Slave received: %h", slave_data_out); [cite: 37]
        [cite_start]$display("Slave sent: %h", slave_data_in); [cite: 38]
        [cite_start]$display("Master received: %h", master_data_out); [cite: 38]
        
        # (CLK_PERIOD);
        $stop;
    end

endmodule