module top (
    input I_clk,
    output reg O_led
);
    // Set up a counter
    reg [25:0] ctr_q = 0;

    always @(posedge I_clk)
    begin
        ctr_q <= ctr_q + 1;
        O_led <= ctr_q[23];
    end

endmodule
