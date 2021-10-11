# Open Source Verilog tools for the Tang Nano

## INSTALL

The synthesis tools can all be installed through Python:

    sudo pip3 install yowasp-yosys --upgrade
    sudo pip3 install yowasp-nextpnr-gowin --upgrade
    sudo pip3 install apycula  --upgrade
 
The final tool is openFPGALoader. It lives [https://github.com/trabucayre/openFPGALoader]. 

    wget https://github.com/trabucayre/openFPGALoader/releases/tag/v0.5.0
 
## Running the blinky example
 
Start with the following module which just flashes some LED's on the board. To make things simple, we have the file tangnano.cst that specifies the name and locations of pins on the tang nano. The relevant part describes the LEDs
 
    module top (
        input clk,
        output [`LEDS_NR-1:0] led
    );

    reg [25:0] ctr_q;
    wire [25:0] ctr_d;

    // Sequential code (flip-flop)
    always @(posedge clk)
        ctr_q <= ctr_d;

    // Combinational code (boolean logic)
    assign ctr_d = ctr_q + 1'b1;
    assign led = ctr_q[25:25-`LEDS_NR];

    endmodule
    
Download the pin descriptios

    wget https://raw.githubusercontent.com/YosysHQ/apicula/master/examples/blinky.v
    wget https://raw.githubusercontent.com/YosysHQ/apicula/master/examples/tangnano.cst

## Using the Makefile

    make blinky-tangnano-prog

Requires openFPGALoader to be installed in /usr/local/bin/openFPGALoader.

### Using the tools by themselves

Now synthesize the verilog, producing a blinky.json file:

    yowasp-yosys -D LEDS_NR=3 -p "synth_gowin -json blinky.json" blinky.v

The next step is to place and route the design onto the tang nano board.

    yowasp-nextpnr-gowin --json blinky.json \
              --write pnrblinky.json \
              --device GW1NR-UV9QN881C6/I5 \
              --cst tangnano.cst

Then generate a programming file:

    gowin_pack -d GW1NR-UV9QN881C6/I5 -o pack.fs pnrblinky.json
   # gowin_unpack -d GW1NR-UV9QN881C6/I5 -o unpack.v pack.fs
   # yosys -p "read_verilog -lib +/gowin/cells_sim.v; clean -purge; show" unpack.v

Finally program the device using openFPGALoader:

    ./usr/local/bin/openFPGALoader -b tangnano pack.fs
