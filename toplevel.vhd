library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- TOPLEVEL
--================================================================================================  
-- Structural toplevel of the Canny edge detector circuit
--------------------------------------------------------------------------------------------------
entity toplevel is
  port (
    clk, rst    : in  std_logic ;
    
    center_pair : in  grd_pair ;
    magn_set    : in  grd_magn_set ;
    
    thresh_bit  : out std_logic
  );
end entity ;

architecture ARCH_TOPLEVEL_0 of toplevel is
  
  -- Intemediary signals
  signal magn_center, magn_a, magn_b : grd_magn ;
begin
  
  -- NMS block A
  -- Magnitude extractions
  NMS_BLK_A : entity work.nms_block_a(ARCH_NMS_BLK_A_0)
  port map (clk, rst,
    center_pair => center_pair,
    magn_arr    => magn_set,
    magn_center => magn_center,
    magn_a      => magn_a,
    magn_b      => magn_b
  ) ;
  
  -- NMS block B
  -- Magnitude comparisons and threshold value
  NMS_BLK_B : entity work.nms_block_b(ARCH_NMS_BLK_B_0)
  port map (clk, rst,
    magn_center => magn_center,
    magn_a      => magn_a,
    magn_b      => magn_b,
    
    thresh_bit  => thresh_bit
  ) ;
end ARCH_TOPLEVEL_0 ;