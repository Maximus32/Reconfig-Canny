library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;
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
  signal mmap_rd_data : std_logic_vector(MMAP_DATA_RANGE);
  
  -- Function "mmap_write"
  -- Writes 'data' to 'addr' of the memory map
  procedure mmap_write (
    constant addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
    constant data       : in  std_logic_vector(MMAP_DATA_RANGE);
    signal mmap_rd_en   : out std_logic;
    signal mmap_wr_en   : out std_logic;
    signal mmap_wr_addr : out std_logic_vector(MMAP_ADDR_RANGE);
    signal mmap_wr_data : out std_logic_vector(MMAP_DATA_RANGE)
  ) is begin
    mmap_rd_en   <= '0';
    mmap_wr_en   <= '1';
    mmap_wr_addr <= addr;
    mmap_wr_data <= data;
    
    -- Wait for a full clock cycle
    wait for 20 ns;
  end procedure;
  
  -- Function "mmap_read"
  -- Reads from 'addr' of the memory map
  procedure mmap_read (
    constant addr       : in  std_logic_vector(MMAP_ADDR_RANGE);
    signal mmap_rd_en   : out std_logic;
    signal mmap_wr_en   : out std_logic;
    signal mmap_rd_addr : out std_logic_vector(MMAP_ADDR_RANGE)
  ) is begin
    mmap_rd_en   <= '1';
    mmap_wr_en   <= '0';
    mmap_rd_addr <= addr;
    
    -- Wait for a full clock cycle
    wait for 20 ns;
  end procedure;
begin
  
  U_USER_APP : entity work.user_app
  port map (clk, rst,
    mmap_wr_en, mmap_wr_addr, mmap_wr_data,
    mmap_rd_en, mmap_rd_addr, mmap_rd_data);
  
  -- Clock signal
  clk <= not clk after 10 ns;
  
  process
  begin
    
    -- System reset
    rst <= '1';
    wait for 20 ns;
    rst <= '0';
    
    -- Write column and row counts
    mmap_write(C_ROWS_ADDR, cnv(IMG_HEIGHT, C_MEM_IN_WIDTH), mmap_rd_en, mmap_wr_en, mmap_wr_addr, mmap_wr_data);
    mmap_write(C_COLS_ADDR, cnv(IMG_WIDTH, C_MEM_IN_WIDTH), mmap_rd_en, mmap_wr_en, mmap_wr_addr, mmap_wr_data);
    
    -- Asset 'GO' signal
    mmap_write(C_GO_ADDR, (0 => '1', others => '0'), mmap_rd_en, mmap_wr_en, mmap_wr_addr, mmap_wr_data);
    
    -- Wait for 'DONE' signal to be asserted
    while mmap_rd_data = cnv(0, C_MEM_IN_WIDTH) loop
      mmap_read(C_DONE_ADDR, mmap_rd_en, mmap_wr_en, mmap_rd_addr);
    end loop;
    
    wait for 60 ns;
    
    report "Simulation complete";
    wait;
  end process;
end TB;
