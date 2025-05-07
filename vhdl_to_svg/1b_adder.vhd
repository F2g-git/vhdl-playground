library IEEE; 
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity oneb_adder is
    port(
        clk : in std_logic;
        a :  in std_logic;
        b :  in std_logic;
        c :  in std_logic;
        o :  out std_logic;
        carry : out std_logic
    );
end oneb_adder;

architecture rtl of oneb_adder is

begin
  
  process(clk)
  begin
    if rising_edge(clk) then
      o <= a xor b xor c;
      carry <= (a and b) or (b and c) or (c and a);
    end if;
  end process;

end;
