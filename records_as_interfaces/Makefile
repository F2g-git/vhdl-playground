all: analysis elab run
	
analysis:
	ghdl -a --std=08 interfaces_pkg.vhd slave.vhd tb_slave.vhd 
elab:
	ghdl -e --std=08 tb_slave
run:
	ghdl -r --std=08 tb_slave --wave --stop-time=1000ns


