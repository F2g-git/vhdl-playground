library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.interfaces_pkg.all;
entity tb_slave is
  end entity tb_slave;

architecture rtl of tb_slave is
  signal clk : std_logic := '0';
  signal tdata : std_logic_vector(31 downto 0 ) := (others => '0'); 
  signal tvalid : STD_LOGIC := '0';
  signal w_axi_send : axi_stream_32_type := (tdata => (others => '0'), tvalid => '0',tready=>'0') ;
  signal w_axi_resp : axi_stream_32_type := (tdata => (others => '0'), tvalid => '0',tready=>'0') ;
  signal start_counter : std_logic := '0';
begin
  clk <= not clk after 5 ns;
  proc_name: process
  begin
    wait until rising_edge(clk);
    wait for 1000 ns;
  end process proc_name; 

  tdata_counter : process(clk)
  begin
    if rising_edge(clk) then
      start_counter <= '1';
      tdata <= std_logic_vector( unsigned(tdata) + 1);
      if tdata(3) = '1' then
        tvalid <= '1';
      else 
        tvalid <= '0';
      end if;
    end if;
  end process;
  w_axi_send.tdata <= tdata;
  w_axi_send.tvalid <= tvalid;
  checker_process : process(clk)
  begin
    if rising_edge(clk) then
      if w_axi_send.tvalid = '1' then
        assert tdata = w_axi_resp.tdata report "The send data did not match the response received" severity FAILURE;
      end if;
    end if;
  end process;
  uut : entity work.slave
  port map(
    i_clk => clk,
    s_axi => w_axi_send,
    m_axi => w_axi_resp
  );
end architecture rtl;
