library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
    port(
        clk : in std_logic;
        a :  in std_logic_vector(3 downto 0);
        b :  in std_logic_vector(3 downto 0);
        o : out std_logic_vector(3 downto 0)
    );
end top;

architecture rtl of top is
  signal w_o : std_logic_vector(3 downto 0);
  signal carry : std_logic_vector(3 downto 0);
begin

  add1: entity work.oneb_adder
   port map(
      clk => clk,
      a => a(0),
      b => b(0),
      c => '0',
      o => w_o(0),
      carry => carry(0)
  );
  add2: entity work.oneb_adder
   port map(
      clk => clk,
      a => a(1),
      b => b(1),
      c => carry(0),
      o => w_o(1),
      carry => carry(1)
  );  
  add3: entity work.oneb_adder
   port map(
      clk => clk,
      a => a(2),
      b => b(2),
      c => carry(1),
      o => w_o(2),
      carry => carry(2)
  );
  add4: entity work.oneb_adder
   port map(
      clk => clk,
      a => a(3),
      b => b(3),
      c => carry(2),
      o => w_o(3),
      carry => carry(3)
  );
  
  process(clk)
  begin
    if rising_edge(clk) then
      o <= w_o;
    end if;
  end process;

end;
