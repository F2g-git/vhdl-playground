library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;
context vunit_lib.com_context;
use vunit_lib.axi_lite_master_pkg.all;

use work.axi_stream_pkg.all;

entity views is 
  generic(
    runner_cfg : string
  );
end entity;

architecture bahvioral of views is 
  constant sim_clk_period           : time := 10 ns;
  signal sim_clk                    : std_logic := '0';
  signal w_uut_areset_n             : std_logic;
  signal w_uut_maxis_control_tdata  : std_logic_vector(31 downto 0) := (others => '0'); 
  signal w_uut_maxis_control_tvalid : std_logic := '0';
  signal w_uut_maxis_control_tready : std_logic := '0';
  signal w_uut_saxis_control_tdata  : std_logic_vector(31 downto 0) := (others => '0');
  signal w_uut_saxis_control_tready : std_logic := '0';
  signal w_uut_saxis_control_tvalid : std_logic := '0';


  constant axis_master : axi_stream_master_t := new_axi_stream_master(data_length => 32);
  constant axis_slave : axi_stream_slave_t := new_axi_stream_slave(data_length => 32);
begin

  sim_clk <= not sim_clk after sim_clk_period/2;
  test_runner       : process
    variable rdata : std_logic_vector(31 downto 0) := (others => '0');
    variable last  : std_logic;
  begin
    test_runner_setup(runner,runner_cfg);
    while test_suite loop
      if run("Test1") then 
        wait until rising_edge(sim_clk);
        w_uut_areset_n <= '0';
        wait for 20 * sim_clk_period;
        w_uut_areset_n <= '1';
        wait until rising_edge(sim_clk);

        push_axi_stream(net,axis_master,x"55555555");
        pop_axi_stream(net,axis_slave,rdata,last);
        assert rdata = x"55555555" report "Test1 failed: Expected 0x55555555, got " & to_hstring(rdata) severity error;
        wait for 100 ns;
      end if;
    end loop;
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1000 ns);


  uut : entity work.axi_stream_ff
  port map(
  s_axis.tdata  <= w_uut_saxis_control_tdata,
                   s_axis.tvalid <= w_uut_saxis_control_tvalid,
                                    s_axis.tready <= w_uut_saxis_control_tready,
                                                     m_axis.tdata  <= w_uut_maxis_control_tdata,
                                                                      m_axis.tvalid <= w_uut_maxis_control_tvalid,
                                                                                       m_axis.tready <= w_uut_maxis_control_tready,
                                                                                                        )

                                                                                       axi_stream_master : entity vunit_lib.axi_stream_master
                                                                                       generic map (
                                                                                         master => axis_master
                                                                                       )
                                                                      port map (
                                                                        aclk     => sim_clk,
                                                                        areset_n => w_uut_areset_n,
                                                                        tvalid   => w_uut_saxis_control_tvalid,
                                                                        tready   => w_uut_saxis_control_tready,
                                                                        tdata    => w_uut_saxis_control_tdata
                                                                      );
                                                     axi_stream_slave : entity vunit_lib.axi_stream_slave
                                                     generic map (
                                                       slave => axis_slave
                                                     )
                                    port map (
                                      aclk     => sim_clk,
                                      areset_n => w_uut_areset_n,
                                      tvalid   => w_uut_maxis_control_tvalid,
                                      tready   => w_uut_maxis_control_tready,
                                      tdata    => w_uut_maxis_control_tdata
                                    );




end architecture;

entity axi_stream_ff is 
  port(
    s_axis : s_saxis_t;
    m_axis : m_axis_t
  );
end entity;

architecture bahvioral of axi_stream_ff is 

begin 
  m_axis.tdata  <= s_axis.tdata;
  m_axis.tvalid <= s_axis.tvalid;
  m_axis.tready <= s_axis.tready;
end architecture;

