module top (
    input  wire       CLK100MHZ,     // the board's 100 MHz clock
    input  wire [7:0] SW,            // 8 slide switches
    output wire [7:0] LED,           // 8 LEDs above the switches
    output wire       UART_RXD_OUT   // the wire to the USB chip
);

    // LEDs show which switches are on
    assign LED = SW;

    // 1-second timer
    reg [26:0] timer = 0;
    reg        send  = 0;

    always @(posedge CLK100MHZ) begin
        if (timer == 100_000_000 - 1) begin
            timer <= 0;
            send  <= 1;       // pulse "start" for one clock
        end else begin
            timer <= timer + 1;
            send  <= 0;
        end
    end

    // Plug in your transmitter
    uart_tx #(.CLKS_PER_BIT(868)) tx_inst (
        .clk  (CLK100MHZ),
        .start(send),
        .data (SW),
        .tx   (UART_RXD_OUT),
        .busy ()
    );

endmodule