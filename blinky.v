module top (
    input clk,
    output led
);
    // Set up a counter
    reg [25:0] ctr_q = 0;

    always @(posedge clk)
    begin
        ctr_q = ctr_q + 1;
        led = ctr_q[23];
    end

endmodule
