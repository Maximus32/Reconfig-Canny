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
    
    magn_center : in  grd_magn_set ;
    magn_a      : in  grd_magn_set ;
    magn_b      : in  grd_magn_set ;
    
    thresh_bit  : out std_logic_vector(BLOCK_W-2-1 downto 0)
  );
end entity ;

architecture ARCH_NMS_BLK_B_0 of nms_block_B is
begin
  process(clk)
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      for i in 0 to BLOCK_W-2-1 loop
        
        -- Assert the threshold bit if the center magnitude exceeds the side-by-side magnitudes
        if (magn_center(i) > magn_a(i) and magn_center(i) > magn_b(i)) then
          thresh_bit(i) <= '1' ;
        else thresh_bit(i) <= '0' ;
        end if ;
      end loop ;
    end if ;
  end process ;
end ARCH_NMS_BLK_B_0 ;