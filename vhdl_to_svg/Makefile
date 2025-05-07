TOP=top

analysis: 
	ghdl -a --std=08 1b_adder.vhd ${TOP}.vhd 

svgjson:
	yosys -m ghdl -p "ghdl --std=08 ${TOP}; prep -top ${TOP}; write_json -compat-int svg.json"

image:
	netlistsvg svg.json -o ${TOP}.svg

all: analysis svgjson image
