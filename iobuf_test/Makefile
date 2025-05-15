analyse:
	ghdl -a --std=08 -P../xilinx-vivado-ghdl/  iobuf.vhd

elab: analyse
	ghdl -e --std=08 -P../xilinx-vivado-ghdl/  iobuf_test

run: elab
	ghdl -r --std=08 -P../xilinx-vivado-ghdl/  iobuf_test --wave=wave.ghw 

all: run
