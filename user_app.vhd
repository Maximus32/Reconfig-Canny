-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity user_app is
    port (
        clk : in std_logic;
        rst : in std_logic;

        -- memory-map interface
        mmap_wr_en   : in  std_logic;
        mmap_wr_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_wr_data : in  std_logic_vector(MMAP_DATA_RANGE);
        mmap_rd_en   : in  std_logic;
        mmap_rd_addr : in  std_logic_vector(MMAP_ADDR_RANGE);
        mmap_rd_data : out std_logic_vector(MMAP_DATA_RANGE)
        );
end user_app;

architecture default of user_app is

    signal go   : std_logic;
    signal size : std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    signal done : std_logic;

    signal mem_in_wr_data       : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
    signal mem_in_wr_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    signal mem_in_wr_addr2      : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0)
    signal mem_in_wr_addr3      : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0)
    signal mem_in_rd_data1      : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
    signal mem_in_rd_data2      : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
    signal mem_in_rd_data3      : std_logic_vector(C_MEM_IN_WIDTH-1 downto 0);
    signal mem_in_rd_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    signal mem_in_wr_en         : std_logic;
    signal mem_in_rd_addr_valid : std_logic;

    signal mem_out_wr_data       : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);
    signal mem_out_wr_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    signal mem_out_rd_data       : std_logic_vector(C_MEM_OUT_WIDTH-1 downto 0);
    signal mem_out_rd_addr       : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);
    signal mem_out_wr_en         : std_logic;
    signal mem_out_wr_data_valid : std_logic;

    --temp signals for datapath
    signal valid_in_bit : std_logic;

    signal reset_addresses   : std_logic;
    signal address_in_enable : std_logic;
    signal wr_en_2           : std_logic;
    signal wr_en_3           : std_logic;
    signal size_signal       : std_logic_vector(C_MEM_ADDR_WIDTH downto 0);

begin

	------------------------------------------------------------------------------
    U_MMAP : entity work.memory_map
        port map (
            clk     => clk,
            rst     => rst,
            wr_en   => mmap_wr_en,
            wr_addr => mmap_wr_addr,
            wr_data => mmap_wr_data,
            rd_en   => mmap_rd_en,
            rd_addr => mmap_rd_addr,
            rd_data => mmap_rd_data,

			-- TODO: connect to appropriate logic
            go              => go,
            size            => size,
            done            => done,

			-- already connected to block RAMs
			-- the memory map functionality writes to the input ram
			-- and reads from the output ram
            mem_in_wr_data  => mem_in_wr_data,
            mem_in_wr_addr  => mem_in_wr_addr,
            mem_in_wr_en    => mem_in_wr_en,
            mem_out_rd_data => mem_out_rd_data,
            mem_out_rd_addr => mem_out_rd_addr
            );
	------------------------------------------------------------------------------


	------------------------------------------------------------------------------
    -- input memory
    -- written to by memory map
    -- read from by controller+datapath
    U_MEM_IN1 : entity work.ram(SYNC_READ)
        generic map (
            num_words  => 2**C_MEM_ADDR_WIDTH,
            word_width => C_MEM_IN_WIDTH,
            addr_width => C_MEM_ADDR_WIDTH)
        port map (
            clk   => clk,
            wen   => mem_in_wr_en,
            waddr => mem_in_wr_addr,
            wdata => mem_in_wr_data,
            raddr => mem_in_rd_addr,  -- TODO: connect to input address generator
            rdata => mem_in_rd_data1); -- TODO: connect to pipeline input

    --this part delays the address enable of the 2nd input RAM
    addr_delay1to2_en : entity work.reg_sync
      port map(
        clk => clk,
        rst => reset_addresses,
        data_in => mem_in_wr_en,
        data_out => wr_en_2
      );

    addr_input_delay1to2 : entity work.reg_n_sync
      generic map(
        reg_width => C_MEM_ADDR_WIDTH
      )
      port map(
        clk => clk,
        rst => '0', --might need to change later during testing
        data_in => mem_in_wr_addr,
        data_out => mem_in_wr_addr2
      );

    -- input memory
    -- written to by memory map
    -- read from by controller+datapath
    U_MEM_IN2 : entity work.ram(SYNC_READ)
        generic map (
            num_words  => 2**C_MEM_ADDR_WIDTH,
            word_width => C_MEM_IN_WIDTH,
            addr_width => C_MEM_ADDR_WIDTH)
        port map (
            clk   => clk,
            wen   => wr_en_2,
            waddr => mem_in_wr_addr2,
            wdata => mem_in_wr_data,
            raddr => mem_in_rd_addr,  -- TODO: connect to input address generator
            rdata => mem_in_rd_data2); -- TODO: connect to pipeline input

    --this part delays the address enable of the 3rd input RAM
    addr_delay2to3_en : entity work.reg_sync
      port map(
        clk => clk,
        rst => reset_addresses,
        data_in => wr_en_2,
        data_out => wr_en_3
      );

    addr_input_delay2to3 : entity work.reg_n_sync
      generic map(
        reg_width => C_MEM_ADDR_WIDTH
      )
      port map(
        clk => clk,
        rst => '0', --might need to change later during testing
        data_in => mem_in_wr_addr2,
        data_out => mem_in_wr_addr3
      );

    -- input memory
    -- written to by memory map
    -- read from by controller+datapath
    U_MEM_IN3 : entity work.ram(SYNC_READ)
        generic map (
            num_words  => 2**C_MEM_ADDR_WIDTH,
            word_width => C_MEM_IN_WIDTH,
            addr_width => C_MEM_ADDR_WIDTH)
        port map (
            clk   => clk,
            wen   => wr_en_3,
            waddr => mem_in_wr_addr3,
            wdata => mem_in_wr_data,
            raddr => mem_in_rd_addr,  -- TODO: connect to input address generator
            rdata => mem_in_rd_data3); -- TODO: connect to pipeline input
	------------------------------------------------------------------------------


	------------------------------------------------------------------------------
    -- output memory
    -- written to by controller+datapath
    -- read from by memory map
    U_MEM_OUT : entity work.ram(SYNC_READ)
        generic map (
            num_words  => 2**C_MEM_ADDR_WIDTH,
            word_width => C_MEM_OUT_WIDTH,
            addr_width => C_MEM_ADDR_WIDTH)
        port map (
            clk   => clk,
            wen   => mem_out_wr_en,
            waddr => mem_out_wr_addr,  -- TODO: connect to output address generator
            wdata => mem_out_wr_data,  -- TODO: connect to pipeline output
            raddr => mem_out_rd_addr,
            rdata => mem_out_rd_data);
	------------------------------------------------------------------------------


	-- TODO: INCLUDE DATA_PATH FROM MAX. THIS IS THE DATA_PATH FROM LAB5 CURRENTLY
	data_path : entity work.datapath
	   port map(
	      clk => clk,
	      rst => rst,
	      in_data => mem_in_rd_data,
	      valid_in => valid_in_bit,
	      valid_out => mem_out_wr_en,
	      out_data => mem_out_wr_data
	   );

  mem_in_address : entity work.addr_gen
    generic map (
      addr_width => C_MEM_ADDR_WIDTH,
      addr_incr  => 1)
    port map(
      clk  => clk,
      rst  => reset_addresses,
      en   => address_in_enable,
      addr => mem_in_rd_addr
    );

  --TODO: this is the controller from Lab 5, but this controller should work with
  --minor modifications (ie: pipeline clear state will need to be longer).
  U_CONTROLLER : entity work.controller
    port map(
      clk => clk,
      rst => rst,
      go => go,
      size => size,
      current_addr => mem_in_rd_addr,
      done => done,
      valid_data => valid_in_bit,
      size_out => size_signal,
      addr_in_en => address_in_enable,
      rst_addr => reset_addresses
    );

    mem_out_address : entity work.addr_gen
      generic map (
        addr_width => C_MEM_ADDR_WIDTH,
        addr_incr  => 1)
      port map (
        clk  => clk,
        rst  => reset_addresses,
        en   => mem_out_wr_en,
        addr => mem_out_wr_addr
      );

end default;
