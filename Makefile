YOSYS ?= yowasp-yosys
NEXTPNR ?= yowasp-nextpnr-gowin
PROGRAMMER ?= /usr/local/bin/openFPGALoader

all: 	blinky-tangnano.fs

unpacked: blinky-tangnano-unpacked.v
	
clean:
	rm -f *.json *.fs *-unpacked.v
	
.PHONY: all clean

%-tangnano-synth.json: %.v
	$(YOSYS) -D LEDS_NR=3 -p "read_verilog $^; synth_gowin -json $@" $^

%-tangnano.json: %-tangnano-synth.json tangnano.cst
	$(NEXTPNR) --json $< --write $@ --device GW1N-LV1QN48C6/I5 --cst tangnano.cst

%-tangnano.fs: %-tangnano.json
	gowin_pack -d GW1N-1 -o $@ $^

%-default-flags-tangnano.json: %-tangnano-synth.json
	$(NEXTPNR) --json $^ --write $@ --device GW1N-LV1QN48C6/I5 \
		--cst iob/tangnano-default.cst

%-tangnano-prog: %-tangnano.fs
	$(PROGRAMMER) -b tangnano $^
	
%-tangnano-unpacked.v: %-tangnano.fs
	gowin_unpack -d GW1N-1 -o $@ $^
