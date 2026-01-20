library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package interfaces_pkg is

type axi_stream_32_type is record
  tdata : std_logic_vector(31 downto 0);
  tvalid : std_logic;
  tready : std_logic;
end record axi_stream_32_type; 

end package interfaces_pkg;
