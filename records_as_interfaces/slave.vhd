library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.interfaces_pkg.all;

entity slave is
  port (
    i_clk : in std_logic;
    s_axi : inout axi_stream_32_type;
    m_axi : inout axi_stream_32_type
  );
end entity slave ;

architecture behavioral of slave  is
begin
  rx_tx : process(i_clk) 
  begin
    if rising_edge(i_clk) then
      if s_axi.tvalid = '1' then
        m_axi.tdata <= s_axi.tdata;
        m_axi.tvalid <= s_axi.tvalid;
        s_axi.tready <= m_axi.tready;
      end if;
    end if;
  end process; 
end architecture behavioral;
