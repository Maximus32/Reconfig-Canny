library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- PREPROCESSING BLOCK
--================================================================================================  
-- Block that takes in 16-bit gradient magnitude and direction values and outputs truncated
-- 8- and 3-bit values respectively
--------------------------------------------------------------------------------------------------
entity preprocessing_blk is
  port (
    clk, rst : in  std_logic ;
    
    magn_in  : in  raw_magn ;
    dir_in   : in  raw_dir ;
    
    magn_out : out grd_magn ;
    dir_out  : out grd_dir
  );
end entity ;

architecture ARCH_PREPROP_BLK_0 of preprocessing_blk is
begin
  process(clk, rst)
    variable dir_intrm  : raw_dir ;
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      dir_intrm := dir_in + 180 ;
		
      magn_out <= magn_in(WIDTH_RAW_MAGN-1 downto WIDTH_RAW_MAGN-WIDTH_GRD_MAGN) ;
      dir_out  <= dir_intrm(WIDTH_RAW_DIR-1 downto WIDTH_RAW_DIR-WIDTH_GRD_DIR) ;
    end if ;
  end process ;
end architecture ;