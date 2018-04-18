library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- NMS BLOCK B
--================================================================================================  
-- Compares the side-by-side magnitudes of the center magnitude and outputs the threshold bit
--------------------------------------------------------------------------------------------------
entity nms_block_B is
  port (
    clk, rst    : in  std_logic ;
    
    magn_center : in  grd_magn ;
    magn_a      : in  grd_magn ;
    magn_b      : in  grd_magn ;
    
    thresh_bit  : out std_logic
  );
end entity ;

architecture ARCH_NMS_BLK_B_0 of nms_block_B is
begin
  process(clk)
    variable magn_center_u : grd_magn_u ;
    variable magn_a_u      : grd_magn_u ;
    variable magn_b_u      : grd_magn_u ;
  begin
    magn_center_u := unsigned(magn_center) ;
    magn_a_u      := unsigned(magn_a) ;
    magn_b_u      := unsigned(magn_b) ;
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      
      -- Assert the threshold bit if the center magnitude exceeds the side-by-side magnitudes
      if (magn_center_u > magn_a_u and magn_center_u > magn_b_u) then
        thresh_bit <= '1' ;
      else thresh_bit <= '0' ;
      end if ;
    end if ;
  end process ;
end ARCH_NMS_BLK_B_0 ;