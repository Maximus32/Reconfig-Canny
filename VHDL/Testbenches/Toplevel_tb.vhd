library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.canny_header.all;

entity toplevel_tb is
end toplevel_tb;

architecture TB of toplevel_tb is
  signal clk, rst   : std_logic := '0';
  
  signal dir_arr    : grd_dir_set;
  signal magn_set   : grd_magn_blk;
  
  signal thresh_out : bit_set;
begin

  -- Emulator toplevel entity
  U_TOPLEVEL : entity work.toplevel
    port map (
      clk        => clk,
      rst        => rst,
      dir_arr    => dir_arr,
      magn_set   => magn_set,
      thresh_out => thresh_out
    );
  
  -- Clock signal
  clk <= not clk after 10 ns;
  
  process
  begin
    
    -- Magnitudes of the surrounding pixels
    magn_set <= (
      cnv_u(20, WIDTH_GRD_MAGN),
      cnv_u(21, WIDTH_GRD_MAGN),
      cnv_u(22, WIDTH_GRD_MAGN),
      cnv_u(23, WIDTH_GRD_MAGN),
      cnv_u(24, WIDTH_GRD_MAGN),
      cnv_u(25, WIDTH_GRD_MAGN),
      cnv_u(31, WIDTH_GRD_MAGN),
      cnv_u(32, WIDTH_GRD_MAGN),
      cnv_u(33, WIDTH_GRD_MAGN),
      cnv_u(29, WIDTH_GRD_MAGN),
      cnv_u(30, WIDTH_GRD_MAGN),
      cnv_u(31, WIDTH_GRD_MAGN),
      cnv_u(32, WIDTH_GRD_MAGN),
      cnv_u(33, WIDTH_GRD_MAGN),
      cnv_u(34, WIDTH_GRD_MAGN)
    );
    
    -- System reset
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    
    -- Iterate through all directions
    for i in 0 to COUNT_GRD_DIR-1 loop
      dir_arr(0) <= cnv_u(i, WIDTH_GRD_DIR);
      dir_arr(1) <= cnv_u(i, WIDTH_GRD_DIR);
      dir_arr(2) <= cnv_u(i, WIDTH_GRD_DIR);
      wait for 40 ns;
    end loop;
    
    report "Simulation complete";
    wait;
  end process;
end TB;
