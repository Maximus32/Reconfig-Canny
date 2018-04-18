library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- THRESHOLD BLOCK A
--================================================================================================  
-- Compares the input gradient magnitude to the high and low thresholds, outputing a binary value
-- for each
--------------------------------------------------------------------------------------------------
entity thresh_block_A is
  port (
    clk, rst  : in  std_logic ;
    magn      : in  grd_magn ;
    
    pass_high : out std_logic ;
    pass_low  : out std_logic
  );
end entity ;

architecture ARCH_THRESH_BLK_A_0 of thresh_block_A is
begin
  process(clk)
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      
      -- Check against high threshold
      if (cnv_to_int(magn) > THRESHOLD_HIGH) then
        pass_high <= '1' ;
      else pass_high <= '0' ;
      end if ;
      
      -- Check against low threshold
      if (cnv_to_int(magn) > THRESHOLD_LOW) then
        pass_low <= '1' ;
      else pass_low <= '0' ;
      end if ;
    end if ;
  end process ;
end ARCH_THRESH_BLK_A_0 ;