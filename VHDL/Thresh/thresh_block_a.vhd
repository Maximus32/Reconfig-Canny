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
    magn_set  : in  grd_magn_set ;
    
    pass_high : out bit_set ;
    pass_low  : out bit_set
  );
end entity ;

architecture ARCH_THRESH_BLK_A_0 of thresh_block_A is
begin
  process(clk)
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      for i in 0 to BLOCK_W-2-1 loop
      
        -- Check against high threshold
        if (cnv_to_int(magn_set(i)) > THRESHOLD_HIGH) then
          pass_high(i) <= '1' ;
        else pass_high(i) <= '0' ;
        end if ;
        
        -- Check against low threshold
        if (cnv_to_int(magn_set(i)) > THRESHOLD_LOW) then
          pass_low(i) <= '1' ;
        else pass_low(i) <= '0' ;
        end if ;
      end loop ;
    end if ;
  end process ;
end ARCH_THRESH_BLK_A_0 ;