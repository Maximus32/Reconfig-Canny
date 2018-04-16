--David Watts
--Controller used for lab 5
--Reconfigurable computing 3/15/18

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.config_pkg.all;
use work.user_pkg.all;

entity controller is
  port(
    clk          : in std_logic;
    rst          : in std_logic;
    go           : in std_logic;
    size         : in std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    current_addr : in std_logic_vector(C_MEM_ADDR_WIDTH - 1 downto 0);
    done         : out std_logic;
    valid_data   : out std_logic;
    size_out     : out std_logic_vector(C_MEM_ADDR_WIDTH downto 0);
    addr_in_en   : out std_logic;
    addr_out_en  : out std_logic; --make this the valid_data output from the datapath
    rst_addr     : out std_logic
  );

end controller;

architecture behavior of controller is

  --STATE is going to keep track of the current state we are in
  signal STATE           : std_logic_vector(3 downto 0) := "0000";
  constant WAIT_STATE    : std_logic_vector(3 downto 0) := "0000";
  constant GO_STATE      : std_logic_vector(3 downto 0) := "0001";
  constant PIPED_STATE   : std_logic_vector(3 downto 0) := "0010"; --valid data is put into pipeline
  constant EMPTY_PIPE    : std_logic_vector(3 downto 0) := "0011"; --there should still be valid results outputting for a couple clock cycles
  constant DONE_STATE    : std_logic_vector(3 downto 0) := "0100";

  signal PIPE_CLEAR : std_logic_vector(3 downto 0) := "0000";

  begin

  process(clk, rst)
  begin

    if rst = '1' then
      done <= '0';
      valid_data <= '0';
      --addr_out_en <= '0';
      addr_in_en <= '0';
      rst_addr <= '1';
      PIPE_CLEAR <= (others => '0');

    elsif rising_edge(clk) then
      rst_addr <= '0';

      case STATE is
        when WAIT_STATE =>
          valid_data <= '0';
          rst_addr <= '1'; --clear the counters
          if go = '1' then
            STATE <= GO_STATE;
            size_out <= size;
            done <= '0';
          end if;

        when GO_STATE =>
          done <= '0';
          rst_addr <= '0';
          addr_in_en <= '1';
          STATE <= PIPED_STATE;

        when PIPED_STATE =>
          done <= '0';
          valid_data <= '1';
          addr_in_en <= '1';
          if current_addr = std_logic_vector(resize(unsigned(size)-1, C_MEM_ADDR_WIDTH)) then
            STATE <= EMPTY_PIPE;
            addr_in_en <= '0';
          end if;

        when EMPTY_PIPE =>
          done <= '0';
          addr_in_en <= '0';
          valid_data <= '0';

          if PIPE_CLEAR = "0010" then --once the pipeline has sent the last valid data, set done = '1'
            STATE <= DONE_STATE;
            done <= '1';
          else
            PIPE_CLEAR <= std_logic_vector(unsigned(PIPE_CLEAR) + 1);
          end if;

        when DONE_STATE =>
          rst_addr <= '1';
          done <= '1';
          valid_data <= '0';

        when others =>
          null;
      end case;

    end if;

  end process;

end behavior;
