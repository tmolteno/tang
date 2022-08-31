YOSYS ?= yowasp-yosys
NEXTPNR ?= yowasp-nextpnr-gowin
PROGRAMMER ?= /usr/local/bin/openFPGALoader
DEVICE ?= GW1N-LV1QN48C6/I5
DEVICE_FAMILY ?= GW1N-1
LED_PIN ?= 3
CST ?= tangnano.cst
BOARD ?= tangnano
MAIN ?= tang_tx
#
# The tang nano 4k is
# DEVICE = GW1NSR-LV4CQN48PC7/I6
# LED = 8

icarus:
	iverilog -v -D "SIM=1" -o${MAIN}.vvp -m testharness testharness.v
	vvp -v ${MAIN}.vvp -lxt2


view:   icarus
	gtkwave test.lx2 view.gtkw




all:
	make DEVICE=GW1N-LV1QN48C6/I5 CST=tangnano.cst BOARD=tangnano ${MAIN}-tangnano-prog

1k:
	make DEVICE=GW1NZ-LV1QN48C6/I5 \
		DEVICE_FAMILY=GW1NZ-1 \
		CST=tangnano1k.cst \
		BOARD=tangnano1k ${MAIN}-tangnano-prog

1k:
	make DEVICE=GW1NZ-LV1QN48C6/I5 \
		DEVICE_FAMILY=GW1NZ-1 \
		CST=tangnano1k.cst \
		BOARD=tangnano1k blinky-tangnano-prog

4k:
	make DEVICE=GW1NSR-LV4CQN48PC7/I6 \
		DEVICE_FAMILY=GW1NS-4 \
		CST=tangnano4k.cst \
		BOARD=tangnano4k ${MAIN}-tangnano-prog

9k:
	make DEVICE=GW1NR-LV9QN88PC6/I5 \
		DEVICE_FAMILY=GW1N-9C \
		CST=tangnano9k_constraints.cst \
		BOARD=tangnano9k ${MAIN}-tangnano-prog

unpacked: blinky-tangnano-unpacked.v
	
clean:
	rm -f *.json *.fs *-unpacked.v
	
.PHONY: all clean 4k

%-tangnano-synth.json: %.v
	$(YOSYS) -D LEDS_NR=${LED_PIN} -p "read_verilog $^; synth_gowin -json $@" $^

%-tangnano.json: %-tangnano-synth.json ${CST}
	$(NEXTPNR) --json $< --write $@ --device ${DEVICE} --cst ${CST}

%-tangnano.fs: %-tangnano.json
	gowin_pack -d ${DEVICE_FAMILY} -o $@ $^

%-default-flags-tangnano.json: %-tangnano-synth.json
	$(NEXTPNR) --json $^ --write $@ --device ${DEVICE} \
		--cst iob/tangnano-default.cst

%-tangnano-prog: %-tangnano.fs
	$(PROGRAMMER) -f -b ${BOARD} $^
	
%-tangnano-unpacked.v: %-tangnano.fs
	gowin_unpack -d ${DEVICE_FAMILY} -o $@ $^
