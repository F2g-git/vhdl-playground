library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;
context vunit_lib.com_context;
use vunit_lib.axi_lite_master_pkg.all;


entity tb_axi_lite_dummy is
  generic (
    runner_cfg : string
  );
end entity tb_axi_lite_dummy ;

architecture tb of tb_axi_lite_dummy  is
  constant sim_clk_period : time := 10 ns;
  signal sim_clk : std_logic := '0';
  signal w_uut_areset_n : std_logic := '1';
  signal w_uut_awvalid : std_logic := '0';
  signal w_uut_awready : std_logic := '0';
  signal w_uut_awaddr : std_logic_vector(0 downto 0) := (others => '0');
  signal w_uut_awprot : std_logic_vector(2 downto 0) := (others => '0');
  signal w_uut_wvalid : std_logic := '0';
  signal w_uut_wready : std_logic := '0';
  signal w_uut_wdata : std_logic_vector(31 downto 0) := (others => '0');
  signal w_uut_wstrb : std_logic_vector(3 downto 0) := (others => '0');
  signal w_uut_bvalid : std_logic := '0';
  signal w_uut_bready : std_logic := '0';
  signal w_uut_bresp : std_logic_vector(1 downto 0) := (others => '0');
  signal w_uut_arvalid : std_logic := '0';
  signal w_uut_arready : std_logic := '0';
  signal w_uut_araddr : std_logic_vector(0 downto 0) := (others => '0');
  signal w_uut_arprot : std_logic_vector(2 downto 0) := (others => '0');
  signal w_uut_rvalid : std_logic := '0';
  signal w_uut_rready : std_logic := '0';
  signal w_uut_rdata : std_logic_vector(31 downto 0) := (others => '0');
  signal w_uut_rresp : std_logic_vector(1 downto 0) := (others => '0');
  signal w_uut_maxis_control_o : std_logic_vector(31 downto 0) := (others => '0');  
  signal w_uut_maxis_control_wr_o : std_logic := '0';
  signal w_uut_maxis_control_rack_i : std_logic := '0';
  signal w_uut_saxis_control_i : std_logic_vector(31 downto 0) := (others => '0');
  signal w_uut_saxis_control_rd_o : std_logic := '0';
  signal w_uut_saxis_control_wack_i : std_logic := '0';

  constant axis_master : axi_stream_master_t := new_axi_stream_master(data_length => 32);
  constant axis_slave : axi_stream_slave_t := new_axi_stream_slave(data_length => 32);
  constant axil_master : bus_master_t := new_bus(data_length => 32, address_length => 1);
begin
  sim_clk <= not sim_clk after sim_clk_period/2;
  test_runner : process
    variable rdata : std_logic_vector(31 downto 0) := (others => '0');
    variable last : std_logic;
  begin
    test_runner_setup(runner,runner_cfg);
    while test_suite loop
      if run("Test1") then 
        wait until rising_edge(sim_clk);
        w_uut_areset_n <= '0';
        wait for 100 ns;
        w_uut_areset_n <= '1';
        wait until rising_edge(sim_clk);
        write_axi_lite(net,axil_master,"0",x"AAAAAAAA");
        wait for 100 ns;
        pop_axi_stream(net,axis_slave,rdata,last);
        assert rdata = x"AAAAAAAA" report "Test1 failed: Expected 0xAAAAAAAA, got " & to_hstring(rdata) severity error;
        push_axi_stream(net,axis_master,x"55555555");
        read_axi_lite(net,axil_master,address=>"1",data=>rdata);
        assert rdata = x"55555555" report "Test1 failed: Expected 0x55555555, got " & to_hstring(rdata) severity error;
        wait for 100 ns;
      end if;
    end loop;
    test_runner_cleanup(runner);
  end process;
  test_runner_watchdog(runner, 1000 ns);

  uut : entity work.axi_lite_dummy
  port map (
    aclk => sim_clk,
    areset_n => w_uut_areset_n,
    awvalid => w_uut_awvalid,
    awready => w_uut_awready,
    awaddr => w_uut_awaddr,
    awprot => w_uut_awprot,
    wvalid => w_uut_wvalid,
    wready => w_uut_wready,
    wdata => w_uut_wdata,
    wstrb => w_uut_wstrb,
    bvalid => w_uut_bvalid,
    bready => w_uut_bready,
    bresp => w_uut_bresp,
    arvalid => w_uut_arvalid,
    arready => w_uut_arready,
    araddr => w_uut_araddr,
    arprot => w_uut_arprot,
    rvalid => w_uut_rvalid,
    rready => w_uut_rready,
    rdata => w_uut_rdata,
    rresp => w_uut_rresp,

    -- Counter control
    maxis_control_o => w_uut_maxis_control_o,
    maxis_control_wr_o => w_uut_maxis_control_wr_o,
    maxis_control_rack_i => w_uut_maxis_control_rack_i,

    saxis_control_i => w_uut_saxis_control_i,
    saxis_control_rd_o => w_uut_saxis_control_rd_o,
    saxis_control_wack_i => w_uut_saxis_control_wack_i
  );

  axi_stream_master : entity vunit_lib.axi_stream_master
  generic map (
    master => axis_master
  )
  port map (
    aclk => sim_clk,
    areset_n => w_uut_areset_n,
    tvalid => w_uut_saxis_control_wack_i,
    tready => w_uut_saxis_control_rd_o,
    tdata => w_uut_saxis_control_i
  );
  axi_lite_master : entity vunit_lib.axi_lite_master
  generic map (
    bus_handle => axil_master
  )
  port map (
    aclk => sim_clk,
    awvalid => w_uut_awvalid,
    awready => w_uut_awready,
    awaddr => w_uut_awaddr,
    wvalid => w_uut_wvalid,
    wready => w_uut_wready,
    wdata => w_uut_wdata,
    wstrb => w_uut_wstrb,
    bvalid => w_uut_bvalid,
    bready => w_uut_bready,
    bresp => w_uut_bresp,
    arvalid => w_uut_arvalid,
    arready => w_uut_arready,
    araddr => w_uut_araddr,
    rvalid => w_uut_rvalid,
    rready => w_uut_rready,
    rdata => w_uut_rdata,
    rresp => w_uut_rresp
  );
  axi_stream_slave : entity vunit_lib.axi_stream_slave
  generic map (
    slave => axis_slave
  )
  port map (
    aclk => sim_clk,
    areset_n => w_uut_areset_n,
    tvalid => w_uut_maxis_control_wr_o,
    tready => w_uut_maxis_control_rack_i,
    tdata => w_uut_maxis_control_o
  );

end architecture tb;
