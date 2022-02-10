module top (
    input SYS_CLK,
    output reg LED_R
);
    // Set up a counter
    reg [25:0] ctr_q = 0;

    always @(posedge SYS_CLK)
    begin
        ctr_q <= ctr_q + 1;
        LED_R <= ctr_q[23];
    end

endmodule
