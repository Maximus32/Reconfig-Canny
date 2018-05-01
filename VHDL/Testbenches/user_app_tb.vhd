-- Greg Stitt
-- University of Florida
-- EEL 5721/4720 Reconfigurable Computing
--
-- File: user_app_tb.vhd
--
-- Description: This file implements a testbench for the simple pipeline
-- when running on the ZedBoard.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

use std.textio.all;

entity user_app_tb is
end user_app_tb;

architecture behavior of user_app_tb is

    constant TEST_SIZE : integer := 144*196;
    constant MAX_CYCLES : integer  := TEST_SIZE*4;

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal mmap_wr_en   : std_logic                         := '0';
    signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE) := (others => '0');

    signal mmap_rd_en   : std_logic                         := '0';
    signal mmap_rd_addr : std_logic_vector(MMAP_ADDR_RANGE) := (others => '0');
    signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE);

    signal sim_done : std_logic := '0';
    
    file   mem_input_magn : text open read_mode is "mem_input_magn.txt";
    file   mem_input_dir  : text open read_mode is "mem_input_dir.txt";
begin

    UUT : entity work.user_app
        port map (
            clk          => clk,
            rst          => rst,
            mmap_wr_en   => mmap_wr_en,
            mmap_wr_addr => mmap_wr_addr,
            mmap_wr_data => mmap_wr_data,
            mmap_rd_en   => mmap_rd_en,
            mmap_rd_addr => mmap_rd_addr,
            mmap_rd_data => mmap_rd_data);

    -- toggle clock
    clk <= not clk after 5 ns when sim_done = '0' else clk;

    -- process to test different inputs
    process

        procedure clearMMAP is
        begin
            mmap_rd_en <= '0';
            mmap_wr_en <= '0';
        end clearMMAP;

        variable errors       : integer := 0;
        variable total_points : real    := 50.0;
        variable min_grade    : real    := total_points*0.25;
        variable grade        : real;

        variable result : std_logic_vector(C_MMAP_DATA_WIDTH-1 downto 0);
        variable done   : std_logic;
        variable count  : integer;
        
        variable line_str : line;
        
        variable tmp1, tmp2 : integer;
    begin

        -- reset circuit
        rst <= '1';
        clearMMAP;
        wait for 200 ns;

        rst <= '0';
        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        -- send size
        mmap_wr_addr <= C_SIZE_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(TEST_SIZE, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

        -- send rows
        mmap_wr_addr <= C_ROWS_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(144, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

        -- send cols
        mmap_wr_addr <= C_COLS_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(196, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

        wait until clk'event and clk = '1';
        wait until clk'event and clk = '1';

        -- Load memory into input RAMs
        mmap_wr_en   <= '1';
        mmap_wr_addr <= (others => '0');
        while (not endfile(mem_input_magn)) loop
          wait until falling_edge(clk);
          
          -- Read magnitude word
          readline(mem_input_magn, line_str);
          read(line_str, tmp1);
          report "Read in: " & integer'image(tmp1);
          
          -- Read directional word
          readline(mem_input_dir, line_str);
          read(line_str, tmp2);
          report "Read in: " & integer'image(tmp2);
          
          mmap_wr_data <= std_logic_vector(to_unsigned(tmp1, C_MMAP_DATA_WIDTH/2)) & std_logic_vector(to_unsigned(tmp2+180, C_MMAP_DATA_WIDTH/2));
          
          -- Increment address
          mmap_wr_addr <= std_logic_vector(unsigned(mmap_wr_addr) + 1);
        end loop;
        clearMMAP;
        
        -- send go = 1 over memory map
        mmap_wr_addr <= C_GO_ADDR;
        mmap_wr_en   <= '1';
        mmap_wr_data <= std_logic_vector(to_unsigned(1, C_MMAP_DATA_WIDTH));
        wait until clk'event and clk = '1';
        clearMMAP;

        done  := '0';
        count := 0;

        -- read the done signal every cycle to see if the circuit has
        -- completed.
        --
        -- equivalent to wait until (done = '1') for TIMEOUT;
        while done = '0' and count < MAX_CYCLES loop

            mmap_rd_addr <= C_DONE_ADDR;
            mmap_rd_en   <= '1';
            wait until clk'event and clk = '1';
            clearMMAP;
            -- give entity one cycle to respond
            wait until clk'event and clk = '1';
            done         := mmap_rd_data(0);
            count        := count + 1;
        end loop;

        if (done /= '1') then
            errors := errors + 1;
            report "Done signal not asserted before timeout.";
        end if;

        -- read outputs from output memory
        for i in 0 to TEST_SIZE-1 loop
            mmap_rd_addr   <= std_logic_vector(to_unsigned(i, C_MMAP_ADDR_WIDTH));
            mmap_rd_en     <= '1';
            wait until clk'event and clk = '1';
            clearMMAP;
            -- give entity one cycle to respond
            wait until clk'event and clk = '1';
            result := mmap_rd_data;
        end loop;  -- i

        report "SIMULATION FINISHED!!!";

        grade := total_points-(real(errors)*total_points*0.05);
        if grade < min_grade then
            grade := min_grade;
        end if;

        report "TOTAL ERRORS : " & integer'image(errors);
        report "GRADE = " & integer'image(integer(grade)) & " out of " &
            integer'image(integer(total_points));
        sim_done <= '1';
        wait;

    end process;
end behavior;
