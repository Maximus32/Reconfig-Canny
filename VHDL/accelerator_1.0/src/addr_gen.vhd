library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

use work.config_pkg.all ;
use work.user_pkg.all ;

-- ADDRESS GENERATOR ----------------------------------------------------------------
-- General purpose address counter with adjustable address range and count increment
-------------------------------------------------------------------------------------
entity addr_gen is
generic (
  addr_width : positive := C_MEM_ADDR_WIDTH ;
  addr_incr  : positive := 1);
port (
  clk  : in std_logic ;
  rst  : in std_logic ;
  en   : in std_logic ;

  addr : out std_logic_vector(addr_width-1 downto 0));
end entity ;

architecture ARCH_INPUT of addr_gen is
    signal addr_tmp : std_logic_vector(addr_width-1 downto 0) ;
begin

  -- Route address tmp to output address
  addr <= addr_tmp ;

  -- MAIN PROCESS
  process(clk)
  begin

    -- On rising clock edge...
    if rising_edge(clk) then

      -- If reset is asserted, set the address to '0'
      if (rst = '1') then
        addr_tmp <= (others => '0' ) ;

      -- If enabled and the address is not at its maximum value, increment it by a set amount
      elsif en = '1' then
        addr_tmp <= std_logic_vector(unsigned(addr_tmp) + addr_incr) ;
      end if ;
    end if ;
  end process ;
end ARCH_INPUT ;
