library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.canny_header.all;

entity toplevel_tb is
end toplevel_tb;

architecture TB of toplevel_tb is
  signal clk, rst     : std_logic := '0';
  
  signal mmap_wr_en   : std_logic;
  signal mmap_wr_addr : std_logic_vector(MMAP_ADDR_RANGE);
  signal mmap_wr_data : std_logic_vector(MMAP_DATA_RANGE);
  signal mmap_rd_en   : std_logic;
  signal mmap_rd_addr : std_logic_vector(MMAP_ADDR_RANGE);
  signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE)
begin

  -- Emulator toplevel entity
  U_USER_APP : entity work.user_app
    port map (clk, rst,
      mmap_wr_en   => mmap_wr_en,
      mmap_wr_addr => mmap_wr_addr,
      mmap_wr_data => mmap_wr_data,
      mmap_rd_en   => mmap_rd_en,
      mmap_rd_addr => mmap_rd_addr,
      mmap_rd_data => mmap_rd_data,
    );
  
  -- Clock signal
  clk <= not clk after 10 ns;
  
  process
  begin
    
    -- System reset
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    
    -- Iterate through all directions
    
    
    report "Simulation complete";
    wait;
  end process;
end TB;
