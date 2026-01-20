all: analysis elab
	
analysis:
	ghdl -a --std=08 types.vhd top.vhd
elab:
	ghdl -e --std=08 top_ent

relaxed: relaxed_analysis relaxed_elab

relaxed_analysis:
	ghdl -a --std=08 -frelaxed types.vhd top.vhd

relaxed_elab:
	ghdl -e --std=08 -frelaxed top_ent


