library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;  -- Required for 'stop'

library UNISIM;
use UNISIM.vcomponents.all;

entity iobuf_test is 

  end entity iobuf_test;

architecture test of iobuf_test is
  signal clk    : std_logic := '0';
  signal w_in   : std_logic := '0';
  signal w_out  : std_logic := '0';
  signal w_io   : std_logic := '0';
  signal w_t    : std_logic := '0';
  signal tests  : std_logic_vector(2 downto 0);
begin
  clk <= not clk after 10 ns;
  process(clk)
  begin 
    if rising_edge(clk) then
      case tests is 
        when "000" =>
          w_in <= 'Z';
          w_out <= 'Z';
          w_t <= '1';
          w_io <= '1';
        when "001" =>
          w_in <= 'Z';
          w_out <= 'Z';
          w_t <= '1';
          w_io <= '0';
        when "010" => 
          w_in <= '1';
          w_out <= 'Z';
          w_t <= '0';
          w_io <= 'Z';
        when "011" =>
          w_in <= '0';
          w_out <= 'Z';
          w_t <= '0';
          w_io <= 'Z';
        when others =>
          w_in <= '0';
          w_out <= '1';
      end case;
    end if;
  end process;
  --
  -- process
  -- begin 
  --   tests <= "000";
  --   wait for 100 ns;
  --   tests <= "001";
  --   wait for 100 ns;
  --   tests <= "010";
  --   wait for 100 ns;
  --   tests <= "011";
  --   wait for 100 ns;
  --   stop;
  -- end process;
  --
  iobuf_inst : IOBUF
  port map (
    O => w_out,
    IO => w_io,
    I => w_in,
    T => w_t
  );
end architecture test;
