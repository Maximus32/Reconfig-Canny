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
    clk, rst     : in  std_logic ;
    
    magn_in      : in  raw_magn ;
    dir_in       : in  raw_dir ;
    
    grd_pair_out : out grd_pair
  );
end entity ;

architecture ARCH_PREPROP_BLK_0 of preprocessing_blk is
begin
  process(clk, rst)
    variable dir_intrm  : raw_dir ;
  begin
    
    -- On async reset...
    if (rst = '1') then
      grd_pair_out <= GRD_PAIR_ZERO ;
      
    -- On clk rising edge...
    elsif (rising_edge(clk)) then
      dir_intrm := dir_in + 180 ;
		
      grd_pair_out.magn <= magn_in(WIDTH_RAW_MAGN-1 downto WIDTH_RAW_MAGN-WIDTH_GRD_MAGN) ;
      grd_pair_out.dir  <= dir_intrm(WIDTH_RAW_DIR-1 downto WIDTH_RAW_DIR-WIDTH_GRD_DIR) ;
    end if ;
  end process ;
end architecture ;