`include "tang_tx.v"


module testharness();

    reg clk;
    reg key;

    wire led, tx;

    initial begin
        $dumpfile("./test.lx2");
        $dumpvars(-1, testharness);
        $dumpon();


        clk = 0;
        key = 0;


        #10 key = 1;


        #100 $finish();
        $dumpoff();
    end

    always #1 clk=!clk;

    top dut(.SYS_CLK(clk), .BTN_B(key), .LED_R(led), .TX_OUT(tx));

endmodule
