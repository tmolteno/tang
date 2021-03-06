# Open Source Verilog tools for the Tang Nano

These amazing tools are part of the yowasp [https://yowasp.org] project that builds cross-platform tools based on YoSys [https://github.com/YosysHQ/].

## INSTALL

The synthesis tools can all be installed through Python:

    sudo pip3 install yowasp-yosys --upgrade
    sudo pip3 install yowasp-nextpnr-gowin --upgrade

There is a script to do this

    ./INSTALL.sh
 
The final tool is openFPGALoader. It lives [https://github.com/trabucayre/openFPGALoader].  There is a script to build this

    ./install_openfpgaloader.sh

Alternately there is a Docker container that can do the same thing...

    docker-compose up --build
 
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

To just do the synthesis:

    make blinky-tangnano.fs
    

    make blinky-tangnano-prog

Requires openFPGALoader to be installed in /usr/local/bin/openFPGALoader. Alternatively, you can use the Dockerfile and docker-compose to program the FPGA 

    docker-compose up --build

## Target the Tang Nano 4k

This uses a different device and pin number. Override these on the make command line

    make DEVICE=GW1NSR-LV4CQN48PC7/I6 LED_PIN=8 blinky-tangnano-prog

### Using the tools by themselves

Now synthesize the verilog, producing a blinky.json file:

    yowasp-yosys -D LEDS_NR=3 -p "read_verilog blinky.v; synth_gowin -json blinky.json" blinky.v

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
