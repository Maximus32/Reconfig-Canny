library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.canny_header.all;

entity toplevel_tb is
end toplevel_tb;

architecture TB of toplevel_tb is
  signal clk, rst   : std_logic := '0';
  
  signal center_pair : grd_pair;
  signal magn_set    : grd_magn_set;
  
  signal thresh_bit  : std_logic;
begin

  -- Emulator toplevel entity
  U_TOPLEVEL : entity work.toplevel
    port map (
      clk         => clk,
      rst         => rst,
      center_pair => center_pair,
      magn_set    => magn_set,
      thresh_bit  => thresh_bit
    );
  
  -- Clock signal
  clk <= not clk after 10 ns;
  
  process
  begin
    
    -- Center pixel magnitude and direction
    center_pair.magn <= cnv_u(25, WIDTH_GRD_MAGN);
    center_pair.dir <= GRD_DIR_N;
    
    -- Magnitudes of the surrounding pixels
    magn_set <= (
      cnv_u(20, WIDTH_GRD_MAGN),
      cnv_u(21, WIDTH_GRD_MAGN),
      cnv_u(22, WIDTH_GRD_MAGN),
      cnv_u(23, WIDTH_GRD_MAGN),
      cnv_u(24, WIDTH_GRD_MAGN),
      cnv_u(25, WIDTH_GRD_MAGN),
      cnv_u(26, WIDTH_GRD_MAGN),
      cnv_u(27, WIDTH_GRD_MAGN)
    );
    
    -- System reset
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    
    -- Iterate through all directions
    for i in 0 to COUNT_GRD_DIR-1 loop
      center_pair.dir <= cnv_u(i, WIDTH_GRD_DIR);
      wait for 40 ns;
    end loop;
    
    report "Simulation complete";
    wait;
  end process;
end TB;
