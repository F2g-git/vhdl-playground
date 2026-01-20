library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity basic_test is
end entity basic_test;

architecture rtl of basic_test is
 type axi_stream_32_type is record
  tdata : std_logic_vector(31 downto 0);
  tvalid : std_logic;
 end record axi_stream_32_type; 
 
 signal clk : std_logic := '0';
 signal tdata : std_logic_vector(31 downto 0 ) := (others => '0'); 
 signal tvalid : STD_LOGIC := '0';
 signal w_axi : axi_stream_32_type := (tdata => (others => '0'), tvalid => '0') ;
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
  w_axi.tdata <= tdata;
  w_axi.tvalid <= tvalid;
  checker_process : process(clk)
  begin
    if rising_edge(clk) then
      if w_axi.tvalid = '1' then
      assert w_axi.tdata = tdata report "The record field did not match its source" severity FAILURE;
      end if;
    end if;
  end process;

end architecture rtl;
