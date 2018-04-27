library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- DATAPATH
--================================================================================================  
-- Structural toplevel of the Canny edge detector datapath
--------------------------------------------------------------------------------------------------
entity datapath is
  port (
    clk, rst   : in  std_logic ;
    
    dir_arr    : in  grd_dir_set ;
    magn_blk   : in  grd_magn_blk ;
    
    thresh_out : out bit_set
  );
end entity ;

architecture ARCH_TOPLEVEL_0 of datapath is
  
  -- Intemediary signals
  signal magn_center, magn_a, magn_b : grd_magn_set ;
  signal thresh_nms, thresh_ths      : bit_set ;
  
  signal magn_set                    : grd_magn_set ;
begin
  
  -- NMS block A
  -- Magnitude extractions
  NMS_BLK_A : entity work.nms_block_a(ARCH_NMS_BLK_A_0)
  port map (clk, rst,
    dir_arr     => dir_arr,
    magn_arr    => magn_blk,
    
    magn_center => magn_center,
    magn_a      => magn_a,
    magn_b      => magn_b
  );
  
  -- NMS block B
  -- Magnitude comparisons and threshold value
  NMS_BLK_B : entity work.nms_block_b(ARCH_NMS_BLK_B_0)
  port map (clk, rst,
    magn_center => magn_center,
    magn_a      => magn_a,
    magn_b      => magn_b,
    
    thresh_bit  => thresh_nms
  );
  
  -- Thresholding block A
  -- Magnitude comparison against a threshold
  THRESH_BLK_A : entity work.thresh_block_A(ARCH_THRESH_BLK_A_0)
  port map (clk, rst,
    magn_set(0)  => magn_blk(4),
    
    pass_high => thresh_ths,
    pass_low  => open
  );
  
  -- Thresholding block
  -- AND of both thresholds
  THRESH_BLK_B : entity work.thresh_block_B(ARCH_THRESH_BLK_B_0)
  port map (clk, rst,
    thresh_nms => thresh_nms,
    thresh_ths => thresh_ths,
    
    thresh_out => thresh_out
  );
    
end ARCH_TOPLEVEL_0 ;