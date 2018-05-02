library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.canny_header.all ;

--------------------------------------------------------------------------------------------------
-- CANNY TOPLEVEL
--================================================================================================  
-- Structural toplevel of the Canny edge detector datapath and buffered memory
--------------------------------------------------------------------------------------------------
entity canny_toplevel is
  port (
    clk, rst   : in  std_logic ;
    
    thresh_out : out bit_set
  );
end entity ;

architecture ARCH_TOPLEVEL_0 of canny_toplevel is
  
  -- Intemediary signals
  signal grd_set  : grd_pair_set;
  
  signal grd_blk  : grd_pair_blk;
  signal magn_blk : grd_magn_blk;
  signal dir_set  : grd_dir_set;
begin
  
  -- Smart buffer
  -- Organizes the RAM outputs into a 3x3 block of gradient data
  SMART_BUFF : entity work.smart_buffer(ARCH_SMART_BUFF_0)
  port map (clk, rst,
    grd_set_in  => grd_set,
    
    grd_arr_out => grd_blk
  );
  
  -- Extract the directional set and magnitude block from the gradient block
  dir_set <= extract_dir_set(grd_blk);
  magn_blk <= extract_magn_blk(grd_blk);
  
  -- Canny datapath
  -- Accepts the directional set and magnitude block of the buffer and
  -- calculates the threshold bit for these inputs
  DATAPATH : entity work.datapath(ARCH_DATAPATH_0)
  port map (clk, rst,
    dir_arr  => dir_set,
    magn_blk => magn_blk,
    
    thresh_out => thresh_out
  );
    
end ARCH_TOPLEVEL_0 ;