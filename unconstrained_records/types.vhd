library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package types is
  subtype t_dword is std_logic_vector(7 downto 0);
  type t_constrained_record is record
    a : std_logic_vector(7 downto 0);
    b : std_logic_vector(7 downto 0);
  end record t_constrained_record;
  type t_unconstrained_record is record
    a : std_logic_vector;
    b : std_logic_vector;
  end record t_unconstrained_record; 
  type t_dependent_record is record
    a : t_dword;
    b : t_dword;
  end record t_dependent_record;
end package types;
