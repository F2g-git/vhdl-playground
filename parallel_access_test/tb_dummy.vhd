library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_dummy is
  generic (
    runner_cfg : string
  );
end tb_dummy;

architecture sim of tb_dummy is

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal w_data_in : std_logic_vector(7 downto 0);
  signal w_data_out : std_logic_vector(7 downto 0);
  signal start_subprocess : std_logic := '0';

begin


clk <= not clk after 5 ns;
test_runner_watchdog(runner, 300 ns);

main : process
    variable cnt : integer := 0;
  begin
   test_runner_setup(runner,runner_cfg);
   if run("test1") then
      while cnt<100 loop
        wait until rising_edge(clk);
        w_data_in <= std_logic_vector(to_unsigned(integer(cnt), 8));
        cnt := cnt + 1;
      end loop;
    elsif run("test2") then
      wait for 200 ns;
      start_subprocess <= '1';
      wait for 200 ns; 
      start_subprocess <= '0';
   end if;
   test_runner_cleanup(runner);
end process;

subprocess : process
    variable cnt : integer := 0;
begin
  if running_test_case = "test1" then
    wait for 400 ns;
  elsif running_test_case = "test2" then
    wait until start_subprocess = '1';
    while start_subprocess = '1' loop
      wait until rising_edge(clk);
      w_data_in <= std_logic_vector(to_unsigned(cnt, 8));
      cnt := cnt + 1;
    end loop;
  end if;
end process;

log : process
begin
  loop
    wait until rising_edge(clk);
    info("Running");
  end loop;
end process;

uut : entity work.dummy_module
  port map (
    clk => clk,
    rst => rst,
    data_in => w_data_in,
    data_out => w_data_out
  );

end sim;
