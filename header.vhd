library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

package canny_header is

  -- CONSTANTS -----------------------------------------------------------------------------------
  
  
  -- TYPE ALIASES --------------------------------------------------------------------------------
  
  
  -- ARRAY TYPES ---------------------------------------------------------------------------------
  
  
  -- Function declarations
  function log2 (num : integer) return integer;
  function cnv (num : integer; size : integer) return std_logic_vector;
  function cnv_to_int (input : std_logic_vector) return integer;
end canny_header ;

package body canny_header is

  -- Function "log2"
  -- Returns the ceiling-ed base-2 logarithm of 'num'
  function log2 (num : integer) return integer is
  begin
    for i in 0 to num loop
      next when 2**i < num;
      return i;
    end loop;
  end log2;

  -- Function "cnv"
  -- Returns the 'std_logic_vector' form of 'num'
  function cnv (num : integer; size : integer) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(num, size));
  end cnv;
  
  -- Function "cnv_to_int"
  -- Returns the integer form of 'input'
  function cnv_to_int (input : std_logic_vector) return integer is
  begin
    return to_integer(unsigned(input));
  end cnv_to_int;
end faultbusters_header;
