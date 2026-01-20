library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package axi_stream is 

type axi_stream_t is record 
  tdata : std_logic_vector(31 downto 0);
  tvalid : std_logic;
  tready : std_logic;
end record axi_stream_t;

view m_axis_t of axi_stream_t is 
tdata : out;
tvalid : out;
tready : in;
end view m_axis_t;

view s_axis_t of axi_stream_t is 
tdata : in;
tvalid : in;
tready : out;
end view m_axis;


end package axi_stream_t;

