library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

package canny_header is

  -- CONSTANTS -----------------------------------------------------------------------------------
  
  -- Widths of magnitude and direction vector types
  constant WIDTH_GRD_MAGN : positive := 8 ;
  constant WIDTH_GRD_DIR  : positive := 3 ;
  
  constant COUNT_GRD_DIR  : positive := 2**WIDTH_GRD_DIR ;
  
  -- Number of pixels in a block
  constant BLOCK_SIZE     : positive := 9 ;
  
  -- CUSTOM TYPE ---------------------------------------------------------------------------------
  subtype grd_magn   is std_logic_vector(WIDTH_GRD_MAGN-1 downto 0) ;
  subtype grd_dir    is std_logic_vector(WIDTH_GRD_DIR-1 downto 0) ;
  
  -- Unsigned versions
  subtype grd_magn_u is unsigned(WIDTH_GRD_MAGN-1 downto 0) ;
  subtype grd_dir_u  is unsigned(WIDTH_GRD_DIR-1 downto 0) ;
  
  -- Magnitdue/direction pair record type
  type grd_pair is record
    magn : grd_magn ;
    dir  : grd_dir ;
  end record ;
  
  -- TYPE-DEPENDENT CONSTANTS --------------------------------------------------------------------
  
  -- Directional constants for the 8 cardinal and ordinal directions
  -- Ordered clockwise
  constant GRD_DIR_N  : grd_dir := "000" ;
  constant GRD_DIR_NE : grd_dir := "001" ;
  constant GRD_DIR_E  : grd_dir := "010" ;
  constant GRD_DIR_SE : grd_dir := "011" ;
  constant GRD_DIR_S  : grd_dir := "100" ;
  constant GRD_DIR_SW : grd_dir := "101" ;
  constant GRD_DIR_W  : grd_dir := "110" ;
  constant GRD_DIR_NW : grd_dir := "111" ;
  
  -- Directional constants for the pixels in a 3x3 block
  -- Ordered clockwise: identically to the directional constants,
  -- excepting the "BLOCK_C" which refers to the center pixel
  constant BLOCK_N  : integer := 0 ;
  constant BLOCK_NE : integer := 1 ;
  constant BLOCK_E  : integer := 2 ;
  constant BLOCK_SE : integer := 3 ;
  constant BLOCK_S  : integer := 4 ;
  constant BLOCK_SW : integer := 5 ;
  constant BLOCK_W  : integer := 6 ;
  constant BLOCK_NW : integer := 7 ;
  constant BLOCK_C  : integer := 8 ;
  
  -- ARRAY TYPES ---------------------------------------------------------------------------------
  
  -- Set of 9 gradient pairs, ordered clockwise with the center as the last element
  type grd_pair_block is array (0 to BLOCK_SIZE-1) of grd_pair ;
  
  -- Set of 8 gradient magnitudes, ordered clockwise
  type grd_magn_set is array (0 to COUNT_GRD_DIR-1) of grd_magn ;
  
  -- Function declarations
  function log2 (num : integer) return integer;
  function cnv (num : integer; size : integer) return std_logic_vector;
  function cnv_to_int (input : std_logic_vector) return integer;
  function cnv_to_int (input : unsigned) return integer;
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
  -- Accepts 'input' of "std_logic_vector"
  -- Returns the integer form of 'input'
  function cnv_to_int (input : std_logic_vector) return integer is
  begin
    return to_integer(unsigned(input));
  end cnv_to_int;
  
  -- Function "cnv_to_int"
  -- Accepts 'input' of "unisgned"
  -- Returns the integer form of 'input'
  function cnv_to_int (input : unsigned) return integer is
  begin
    return to_integer(input);
  end cnv_to_int;
end canny_header;
