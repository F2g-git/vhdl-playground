library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.types.all;

entity top_ent is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           done : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0));
end top_ent;

architecture rtl of top_ent is
  signal constrained_record : t_constrained_record; 
  signal dependent_record : t_dependent_record;
  

  signal from_constrained_instance : std_logic_vector(constrained_record.a'length downto 0);
  signal from_dependent_instance : std_logic_vector(dependent_record.a'length downto 0);
  signal from_constrained_type : std_logic_vector(t_constrained_record.a'length downto 0);
  signal from_dependent_type : std_logic_vector(t_dependent_record.a'length downto 0);
begin
  process (clk, rst)  
    variable cnt : integer := 0;
  begin
    if rising_edge(clk) then
      cnt := cnt + 1; 
    end if;
  end process;
  
  
end architecture rtl;
