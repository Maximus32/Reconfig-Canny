--David Watts
--This register is used to sync the valid bit with the datapath

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity reg_sync is
  port(
    clk        : in std_logic;
    rst        : in std_logic;
    delay_time : in std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    data_in    : in std_logic;
    data_out   : out std_logic
  );
end reg_sync;

architecture behavior of reg_sync is

  signal counter : std_logic_vector(C_MEM_ADDR_WIDTH downto 0) := (others => '0'); --counter to determine delay output
  --the number of cols is delay_time
begin

  process(clk, rst)
  begin

    if rst = '1' then
      data_out <= '0';
      counter <= (others => '0');
    elsif clk'event and clk = '1' then
      if counter = std_logic_vector(resize(unsigned(delay_time)-1, C_MEM_ADDR_WIDTH-1)) then
        data_out <= data_in;
      else
        data_out <= '0';
        counter <= std_logic_vector(unsigned(counter) + 1);
      end if;
    end if;

  end process;

end behavior;
