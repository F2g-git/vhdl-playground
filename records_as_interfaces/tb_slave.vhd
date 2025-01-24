library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

library work;
use work.interfaces_pkg.all;

entity tb_slave is
  generic (
    runner_cfg : STRING
          );
end entity tb_slave;

architecture rtl of tb_slave is
 signal clk : std_logic := '0';
 signal w_axi : axi_stream_32_type := (tdata => (others => '0'), tvalid => '0') ;
 signal start_counter : std_logic := '0';
begin
  clk <= not clk after 5 ns;
 proc_name: process
  begin
    test_runner_setup(runner,runner_cfg);
    while test_suite loop 
      if run("Test1") then 
        wait until rising_edge(clk);
        wait for 1000 ns;
        w_axi.tdata <= (others => '0');
        wait for 300 ns;
      elsif run("Test2") then
      end if;
    end loop;
    test_runner_cleanup(runner);
  end process proc_name; 
  
  tdata_counter : process(clk)
  begin
    if rising_edge(clk) then
      start_counter <= '1';
      w_axi.tdata <= std_logic_vector( unsigned(w_axi.tdata) + 1);
      if w_axi.tdata(3) = '1' then
        w_axi.tvalid <= '1';
      else 
        w_axi.tvalid <= '0';
      end if;
    end if;
  end process;
  uut : entity work.slave 
 port map(
   s_axi => w_axi
  );
end architecture rtl;
