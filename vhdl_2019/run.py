from vunit import VUnit
from pathlib import Path
from vunit.sim_if.factory import SIMULATOR_FACTORY
from vivado_util import compile_standard_libraries

ROOT = Path(__file__).parent
SRC_PATH = ROOT / "src"

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

# Optionally add VUnit's builtin HDL utilities for checking, logging, communication...
# See http://vunit.github.io/hdl_libraries.html.
vu.add_vhdl_builtins()


SC = SIMULATOR_FACTORY.select_simulator()
compile_standard_libraries(
    vu, output_path=ROOT / ("xilinx-vivado-" + SC.name), std="08"
)
vu.add_osvvm()

# Create library 'lib'
lib = vu.add_library("lib")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.vhd")

vu.add_verification_components()

compile_opts = ["-frelaxed", "-fexplicit", "--ieee=synopsys"]
# Set compile and simulation options for GHDL
vu.set_compile_option("ghdl.a_flags", compile_opts)
vu.set_sim_option("ghdl.elab_flags", ["-fexplicit", "--ieee=synopsys", "-frelaxed"])
vu.set_sim_option("ghdl.sim_flags", ["--ieee-asserts=disable"])
# Run vunit function
vu.main()
