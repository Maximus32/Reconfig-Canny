--David Watts
--This register is used to sync the valid bit with the datapath

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_n_sync is
  generic(
    reg_width : positive
  );
  port(
    clk      : in std_logic;
    rst      : in std_logic;
    data_in  : in std_logic_vector(reg_width-1 downto 0);
    data_out : out std_logic_vector(reg_width-1 downto 0)
  );
end reg_n_sync;

architecture behavior of reg_n_sync is

begin

  process(clk, rst)
  begin

    if rst = '1' then
      data_out <= (others => '0');
    elsif clk'event and clk = '1' then
      data_out <= data_in;
    end if;

  end process;

end behavior;
