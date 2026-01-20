TOP=iobuf_test
yosys=/home/roessfl/oss-cad-suite/bin/yosys
analyse:
	ghdl -a --std=08 -P../xilinx-vivado-ghdl/  iobuf.vhd

elab: analyse
	ghdl -e --std=08 -P../xilinx-vivado-ghdl/  ${TOP}

run: elab
	ghdl -r --std=08 -P../xilinx-vivado-ghdl/  ${TOP} --wave=wave.ghw 

svgjson:
	${yosys} -m ghdl -p "ghdl --std=08 ${TOP}; prep -top ${TOP}; write_json -compat-int svg.json"

image: svgjson
	netlistsvg svg.json -o ${TOP}.svg

all: run
