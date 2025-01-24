library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.interfaces_pkg.all;

entity slave is
  port (
   s_axi : inout axi_stream_32_type 
  );
end entity slave ;

architecture behavioral of slave  is
signal  w_data : std_logic_vector(32 downto 0);
signal  w_valid : std_logic;
begin
  
w_data <= s_axi.tdata;
w_valid <= s_axi.tvalid;
  
end architecture behavioral;
