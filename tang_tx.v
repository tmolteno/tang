
module top (
    input SYS_CLK,
    input SW1,
    output LED1,
    output LED2,
    output TX_OUT);

    tang_tx dut(.clk_27MHz(SYS_CLK),
                .key(SW1),
                .status_led(LED1),
                .key_led(LED2),
                .tx_out(TX_OUT));

endmodule

module tang_tx(input clk_27MHz,
    input key,
    output status_led,
    output key_led,
    output tx_out);

    // Set up a counter
    reg [24:0] ctr_q = 0;
    reg tx_out = 0;
    reg status_led = 0;
    reg key_led = 0;


    always @(posedge clk_27MHz)
    begin
        if (ctr_q > 24'h7FFFFF)
        begin
            ctr_q = 0;
            status_led <= !status_led;
        end
        else
            ctr_q <= ctr_q + 1;


        if (key == 0) begin
            tx_out <= !tx_out;
            key_led <= 0;
        end else begin
            key_led <= 1;
        end
    end

endmodule

