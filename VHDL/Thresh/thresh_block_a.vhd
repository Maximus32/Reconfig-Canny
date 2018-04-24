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
    magn_arr  : in  grd_magn_set ;
    
    pass_high : out bit_set ;
    pass_low  : out bit_set
  );
end entity ;

architecture ARCH_THRESH_BLK_A_0 of thresh_block_A is
  signal pass_pipe_h : bit_set ;
  signal pass_pipe_l : bit_set ;
begin
  process(clk)
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      for i in 0 to BLOCK_W-2-1 loop
        
        -- Check against high threshold
        if (cnv_to_int(magn_arr(i)) > THRESHOLD_HIGH) then
          pass_pipe_h(i) <= '1' ;
        else pass_pipe_h(i) <= '0' ;
        end if ;
        
        -- Check against low threshold
        if (cnv_to_int(magn_arr(i)) > THRESHOLD_LOW) then
          pass_pipe_l(i) <= '1' ;
        else pass_pipe_l(i) <= '0' ;
        end if ;
        
        -- Pass elements through the pipes
        pass_low  <= pass_pipe_l ;
        pass_high <= pass_pipe_h ;
      end loop ;
    end if ;
  end process ;
end ARCH_THRESH_BLK_A_0 ;