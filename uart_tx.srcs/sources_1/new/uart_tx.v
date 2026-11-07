module uart_tx #(parameter CLKS_PER_BIT = 868) (
    input  wire       clk,
    input  wire       start,        // pulse high for 1 clock to send
    input  wire [7:0] data,         // the byte to send
    output reg        tx   = 1'b1,  // the serial line (idle = 1)
    output reg        busy = 1'b0   // high while sending
);
    localparam IDLE = 2'd0, START = 2'd1, DATA = 2'd2, STOP = 2'd3;

    reg [1:0] state     = IDLE;
    reg [9:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] shift_reg = 0;

    always @(posedge clk) begin
        case (state)

            IDLE: begin
                tx        <= 1'b1;
                busy      <= 1'b0;
                clk_count <= 0;
                bit_index <= 0;
                if (start) begin
                    shift_reg <= data;
                    busy      <= 1'b1;
                    state     <= START;
                end
            end

            START: begin
                tx <= 1'b0;
                if (clk_count < CLKS_PER_BIT - 1) begin
    clk_count <= clk_count + 1;
end else begin
    clk_count <= 0;
    state <= DATA;
end
              
            end

            DATA: begin
                tx <= shift_reg[bit_index];
                if (clk_count < CLKS_PER_BIT - 1) begin
                    clk_count <= clk_count + 1;
                end else begin
                    clk_count <= 0;
                    if (bit_index < 7) begin 
                        bit_index <= bit_index + 1;
                    end else begin
                        bit_index <= 0;
                        state <= STOP;
                    end
                end
                       
            end

            STOP: begin
                tx <= 1'b1;
                if (clk_count < CLKS_PER_BIT - 1) begin
    clk_count <= clk_count + 1;
    end else begin
        clk_count <= 0;
        state <= IDLE;
    end
   end            

        endcase
    end
endmodule