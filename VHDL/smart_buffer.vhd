--David Watts
--Reconfig final project
--smart buffer is used to 'stage' the data from ram into a quickly useable format

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;


entity smart_buffer is
  port(
    clk    : in std_logic;
    rst    : in std_logic;
    data1  : in grd_pair; --upper 8 bits are the magnitudes, lower 3 are angles
    data2  : in grd_pair; --connect to ram2
    data3  : in grd_pair; --connect to ram3
    out_pair_arr : out grd_pair_arr
  );
end smart_buffer;

architecture behavior of smart_buffer is

  constant PIPE_SIZE    : natural := 1918*3;
  constant PIPE_START_1 : natural := (1918*3) - 11;
  constant PIPE_START_2 : natural := (1918*3) - 22;

  signal pipe           : std_logic_vector(PIPE_SIZE downto 0); --1920x1080 image is the only size we're doing now, 1918 rows will be input

  begin

    pipe(PIPE_SIZE downto PIPE_SIZE-11) <= data1;
    pipe(PIPE_START_1 downto PIPE_START_1-11) <= data2;
    pipe(PIPE_START_2 downto PIPE_START_2-11) <= data3;

    process(clk, rst)
    begin

      if rst = '1' then
        pipe <= (others => '0');
      elsif clk = '1' and clk'event then



    end if;


  end process;

end behavior;
