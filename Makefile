YOSYS ?= yowasp-yosys
NEXTPNR ?= yowasp-nextpnr-gowin
PROGRAMMER ?= /usr/local/bin/openFPGALoader
DEVICE ?= GW1N-LV1QN48C6/I5
LED_PIN ?= 3
CST ?= tangnano.cst
BOARD ?= tangnano
#
# The tang nano 4k is
# DEVICE = GW1NSR-LV4CQN48PC7/I6
# LED = 8

all:
	make DEVICE=GW1N-LV1QN48C6/I5 CST=tangnano.cst BOARD=tangnano blinky-tangnano-prog

4k:
	make DEVICE=GW1NSR-LV4CQN48PC7/I6 CST=tangnano4k.cst BOARD=tangnano4k blinky-tangnano-prog
	
unpacked: blinky-tangnano-unpacked.v
	
clean:
	rm -f *.json *.fs *-unpacked.v
	
.PHONY: all clean 4k

%-tangnano-synth.json: %.v
	$(YOSYS) -D LEDS_NR=${LED_PIN} -p "read_verilog $^; synth_gowin -json $@" $^

%-tangnano.json: %-tangnano-synth.json ${CST}
	$(NEXTPNR) --json $< --write $@ --device ${DEVICE} --cst ${CST}

%-tangnano.fs: %-tangnano.json
	gowin_pack -d ${DEVICE} -o $@ $^

%-default-flags-tangnano.json: %-tangnano-synth.json
	$(NEXTPNR) --json $^ --write $@ --device ${DEVICE} \
		--cst iob/tangnano-default.cst

%-tangnano-prog: %-tangnano.fs
	$(PROGRAMMER) -b ${BOARD} $^
	
%-tangnano-unpacked.v: %-tangnano.fs
	gowin_unpack -d ${DEVICE} -o $@ $^
