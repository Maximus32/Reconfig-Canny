--David Watts
--This register is used to sync the valid bit with the datapath

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity address_gen_other_ram is
  port(
    clk      : in std_logic;
    rst      : in std_logic;
    en       : in std_logic;
    addr_out : out std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0)
  );
end address_gen_other_ram;

architecture behavior of address_gen_other_ram is

signal addr_sig : std_logic_vector(C_MEM_ADDR_WIDTH-1 downto 0);

  begin

  process(clk, rst)
  begin

    if rst = '1' then
      addr_sig <= (others => '0');
    elsif clk = '1' and clk'event then
      if en = '1' then
        addr_sig <= std_logic_vector(unsigned(addr_sig) + 1);
      else
        addr_sig <= (others => '0');
      end if;
    end if;

  end process;

  addr_out <= addr_sig;

end behavior;
