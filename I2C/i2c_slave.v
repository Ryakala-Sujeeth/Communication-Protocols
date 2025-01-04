module i2c_slave (
    input wire clk,          
    input wire reset,        
    
    output reg [7:0] data_out, 
    input wire [7:0] data_in,  
    inout wire sda,         
    input wire scl,
    output state         
);

   
    localparam IDLE        = 3'b000;
    localparam ADDRESS     = 3'b001;
    localparam ACK_ADDRESS = 3'b010;
    localparam READ        = 3'b011;
    localparam WRITE       = 3'b100;
    localparam STOP    = 3'b101;
    reg [6:0] addr =7'b1010101;
    reg [2:0] state, next_state; 

    reg [3:0] bit_counter;      
    reg sda_out;               
    reg sda_dir;               

    reg rw;                     
    reg [6:0] master_addr;      
    reg [7:0] buffer;          

    assign sda = sda_dir ? sda_out : 1'bz;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            bit_counter <= 0;
        end else begin
            state <= next_state;
            if (state == ADDRESS || state == READ || state == WRITE) begin
                bit_counter <= bit_counter + 1;
            end else begin
                bit_counter <= 0;
            end
        end
    end

    
    always @(*) begin
        next_state = state;
        sda_out = 1;
        sda_dir = 0;

        case (state)
            IDLE: begin
                if (!sda && scl) begin 
                    next_state = ADDRESS;
                end
            end

            ADDRESS: begin
                if (bit_counter < 7) begin
                    master_addr[6 - bit_counter] = sda; 
                end else if (bit_counter == 7) begin
                    rw = sda; 
                end else begin
                    
                    next_state = ACK_ADDRESS;
                end
            end

            ACK_ADDRESS: begin
                sda_dir = 1;
                sda_out = (master_addr == addr) ? 1'b0 : 1'b1; 
                
                if (!scl) next_state = (master_addr == addr) ? (rw ? READ : WRITE) : IDLE;
            end

            READ: begin
                sda_dir = 1;
                if (bit_counter < 8) begin
                    sda_out = data_in[7 - bit_counter];
                end else begin
                    next_state = STOP;
                end
            end

            WRITE: begin
                sda_dir = 0;
                if (bit_counter < 8) begin
                    buffer[7 - bit_counter] = sda;
                end else begin
                    next_state = STOP;
                    data_out=buffer;
                end
            end

            STOP: begin
                
                sda_dir = 1'b0;
                if(scl==1 && sda==1)
                next_state = IDLE;
                    
                
            end
        endcase
    end
endmodule
