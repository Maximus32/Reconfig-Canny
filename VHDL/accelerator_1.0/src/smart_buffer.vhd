--David Watts
--Reconfig final project
--smart buffer is used to 'stage' the data from ram into a quickly useable format

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.canny_header.all;

--use work.config_pkg.all;
--use work.user_pkg.all;


entity smart_buffer is
  port(
    clk, rst    : in std_logic;
    
    grd_set_in  : in grd_pair_set;
    
    grd_arr_out : out grd_pair_blk
  );
end smart_buffer;

architecture ARCH_SMART_BUFF_0 of smart_buffer is
  
  -- A set of registers holding the value of the current 3x3 block
  signal pipe_blk : grd_pair_blk;
begin
  process(clk, rst)
    variable blk_l : natural ;
    variable blk_r : natural ;
  begin
    if (rst = '1') then
      for index in 0 to BLOCK_SIZE-1 loop
        pipe_blk(index) <= GRD_PAIR_ZERO ;
		end loop ;
      
    -- On rising edge of clock...
    elsif (rising_edge(clk)) then
      
      -- For each row...
      for row in 0 to BLOCK_H-1 loop
        
        -- Left and right row coordinates
        blk_l := BLOCK_W*row;
        blk_r := BLOCK_W*(row+1)-1;
        
        -- Shift out all 9 gradient pairs to the datapath
        grd_arr_out <= pipe_blk;
        
        -- Shift contents down the pipe block
        pipe_blk(blk_l+1 to blk_r) <= pipe_blk(blk_l to blk_r-1);
        
        -- Shift in next 3 gradient pairs from memory
        pipe_blk(blk_l) <= grd_set_in(row);
      end loop;
    end if;
  end process;
end ARCH_SMART_BUFF_0;
