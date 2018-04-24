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
entity thresh_block_B is
  port (
    clk, rst   : in  std_logic ;
    thresh_nms : in  bit_set ;
    thresh_ths : in  bit_set ;
    
    thresh_out : out bit_set
  );
end entity ;

architecture ARCH_THRESH_BLK_B_0 of thresh_block_B is
begin
  process(clk)
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      for i in 0 to BLOCK_W-2-1 loop
        thresh_out(i) <= thresh_nms(i) and thresh_ths(i) ;
      end loop ;
    end if ;
  end process ;
end ARCH_THRESH_BLK_B_0 ;