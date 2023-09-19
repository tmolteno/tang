`include "tang_tx.v"


module testharness();

    reg clk;
    reg key;

    wire led1, led2, tx;

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

    top dut(.SYS_CLK(clk), .SW1(key), .LED1(led1), .LED2(led2), .TX_OUT(tx));

endmodule
