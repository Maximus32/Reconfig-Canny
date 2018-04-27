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
    dir_arr     : in  grd_dir_set ;
    magn_arr    : in  grd_magn_blk ;
    
    magn_center : out grd_magn_set ;
    magn_a      : out grd_magn_set ;
    magn_b      : out grd_magn_set
  );
end entity ;

architecture ARCH_NMS_BLK_A_0 of nms_block_A is
begin
  process(clk)
    variable index_a : natural ;
    variable index_b : natural ;
  begin
    
    -- On clk rising edge...
    if (rising_edge(clk)) then
      
      -- Calculate indices of magnitudes
      for i in 0 to BLOCK_W-2-1 loop
        
        -- Select the perpendicular index located clockwise of the direction
        case dir_arr(i) is
        when GRD_DIR_N  => index_a := 5 ;
        when GRD_DIR_NE => index_a := 8 ;
        when GRD_DIR_E  => index_a := 7 ;
        when GRD_DIR_SE => index_a := 6 ;
        when GRD_DIR_S  => index_a := 3 ;
        when GRD_DIR_SW => index_a := 0 ;
        when GRD_DIR_W  => index_a := 1 ;
        when GRD_DIR_NW => index_a := 2 ;
        when others     => index_a := 0 ;
        end case;
        
        -- Select the perpendicular index located counterclockwise of the direction
        case dir_arr(i) is
        when GRD_DIR_N  => index_b := 3 ;
        when GRD_DIR_NE => index_b := 6 ;
        when GRD_DIR_E  => index_b := 7 ;
        when GRD_DIR_SE => index_b := 8 ;
        when GRD_DIR_S  => index_b := 5 ;
        when GRD_DIR_SW => index_b := 2 ;
        when GRD_DIR_W  => index_b := 1 ;
        when GRD_DIR_NW => index_b := 0 ;
        when others     => index_b := 0 ;
        end case;
        
        -- Add in unrolling offset amount to both indices
        -- Use indices to get the magnitdues
        magn_a(i) <= magn_arr(index_a + i) ;
        magn_b(i) <= magn_arr(index_b + i) ;
        
        -- Center pixel magnitude
        magn_center(i) <= magn_arr(4 + i) ;
      end loop ;
    end if ;
  end process ;
end ARCH_NMS_BLK_A_0 ;