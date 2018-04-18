library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- NMS BLOCK A
--================================================================================================  
-- Extracts the two side-by-side magnitdues of the center pixel, passing them onward for
-- comparison in the NMS block B
--------------------------------------------------------------------------------------------------
entity nms_block_A is
  port (
    clk, rst    : in  std_logic ;
    center_pair : in  grd_pair ;
    magn_arr    : in  grd_magn_set ;
    
    magn_center : out grd_magn ;
    magn_a      : out grd_magn ;
    magn_b      : out grd_magn
  );
end entity ;

architecture ARCH_NMS_BLK_A_0 of nms_block_A is
begin
  process(clk)
    variable grd_dir_2plus  : grd_dir_u ;
    variable grd_dir_2minus : grd_dir_u ;
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      grd_dir_2plus  := unsigned(center_pair.dir) + 2 ;
      grd_dir_2minus := unsigned(center_pair.dir) - 2 ;
      
      -- Select the magnitudes on either side of the center pixel
      magn_a <= magn_arr(cnv_to_int(grd_dir_2plus)) ;
      magn_b <= magn_arr(cnv_to_int(grd_dir_2minus)) ;
      
      -- Center pixel magnitude
      magn_center <= center_pair.magn ;
    end if ;
  end process ;
end ARCH_NMS_BLK_A_0 ;