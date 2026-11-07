`timescale 1ns / 1ps

module uart_tx_tb;

    // Signals going INTO the transmitter (we control these)
    reg        clk   = 0;
    reg        start = 0;
    reg  [7:0] data  = 0;

    // Signals coming OUT of the transmitter (we watch these)
    wire       tx;
    wire       busy;

    // Plug in your transmitter ("dut" = device under test)
    uart_tx #(.CLKS_PER_BIT(868)) dut (
        .clk  (clk),
        .start(start),
        .data (data),
        .tx   (tx),
        .busy (busy)
    );

    // Make a 100 MHz clock: flip clk every 5 ns
    always #5 clk = ~clk;

    // The test script
    initial begin
        #100;               // wait 100 ns
        data  = 8'h41;    // the letter "A" in hex
        start = 1;          // press "send"
        #10;                // hold it for one clock cycle
        start = 0;          // let go
        #100000;            // wait 100 us (one frame takes about 87 us)
        $finish;            // end the simulation
    end

endmodule