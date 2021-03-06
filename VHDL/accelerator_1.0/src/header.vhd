library ieee ;

use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

package canny_header is

  -- CONSTANTS -----------------------------------------------------------------------------------

  -- Input image dimensions
  -- Minus 2 for the edge loss in the Canny algorithm
  constant IMG_WIDTH  : positive := 1920-2;
  constant IMG_HEIGHT : positive := 1080-2;

  -- Widths of magnitude and direction vector types
  constant WIDTH_GRD_MAGN : positive := 8 ;
  constant WIDTH_GRD_DIR  : positive := 3 ;

  constant WIDTH_RAW_MAGN : positive := 16 ;
  constant WIDTH_RAW_DIR  : positive := 16 ;

  constant COUNT_GRD_DIR  : positive := 2**WIDTH_GRD_DIR ;

  -- Number of pixels in a block
  constant BLOCK_W        : positive := 3 ;
  constant BLOCK_H        : positive := 3 ;
  constant BLOCK_SIZE     : positive := BLOCK_W * BLOCK_H ;

  -- Number of times unrolled
  constant UNROLL_CNT     : positive := 1 ;

  -- High and low threshold values
  constant THRESHOLD_HIGH : positive := 22 ;
  constant THRESHOLD_LOW  : positive := 10 ;

  -- CUSTOM TYPE ---------------------------------------------------------------------------------
  subtype grd_magn   is unsigned(WIDTH_GRD_MAGN-1 downto 0) ;
  subtype grd_dir    is unsigned(WIDTH_GRD_DIR-1 downto 0) ;

  subtype raw_magn   is unsigned(WIDTH_RAW_MAGN-1 downto 0) ;
  subtype raw_dir    is unsigned(WIDTH_RAW_DIR-1 downto 0) ;

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

  -- Zero'ed out gradient pair
  constant GRD_PAIR_ZERO : grd_pair := (magn => (others => '0'), dir => GRD_DIR_N) ;

  -- ARRAY TYPES ---------------------------------------------------------------------------------


  -- Organization of Pixels in a 3-times unrolled 3x5 block
  -- Pixels marked with '*'s are "center pixes" which are being operated on
  --   ___ ___ ___
  --  |  0|  1|  2|
  --  |___|___|___|
  --  |  3| *4|  5|
  --  |___|___|___|
  --  |  6|  7|  8|
  --  |___|___|___|
  --

  -- Set of 9 gradient pairs, ordered as shown in the figure
  type grd_pair_blk is array (0 to BLOCK_SIZE-1) of grd_pair ;

  -- Set of 3 gradient pairs, ordered from left to right
  type grd_pair_set is array (BLOCK_W-1 downto 0) of grd_pair ;

  -- Set of 9 gradient magnitudes belonging to a 3x3 pixel block
  -- Ordered as shown in the figure
  type grd_magn_blk is array (0 to BLOCK_SIZE-1) of grd_magn ;

  -- Set of 3 gradient magnitudes and directions of the center pixels
  -- Ordered from left to right
  type grd_magn_set is array (0 to UNROLL_CNT-1) of grd_magn ;
  type grd_dir_set is array (0 to UNROLL_CNT-1) of grd_dir ;
  subtype bit_set is std_logic_vector(0 to UNROLL_CNT-1) ;

  -- Function declarations
  function log2 (num : positive) return integer;
  function cnv (num : integer; size : positive) return std_logic_vector;
  function cnv_u (num : integer; size : positive) return unsigned;
  function cnv_to_int (input : std_logic_vector) return integer;
  function cnv_to_int (input : unsigned) return integer;

  function extract_dir_set (blk : grd_pair_blk) return grd_dir_set;
  function extract_magn_blk (blk : grd_pair_blk) return grd_magn_blk;
end canny_header ;

package body canny_header is

  -- Function "log2"
  -- Returns the ceiling-ed base-2 logarithm of 'num'
  function log2 (num : positive) return integer is
  begin
    for i in 0 to num loop
      next when 2**i < num;
      return i;
    end loop;
  end log2;

  -- Function "cnv"
  -- Returns the 'std_logic_vector' form of 'num'
  function cnv (num : integer; size : positive) return std_logic_vector is
  begin
    return std_logic_vector(to_unsigned(num, size));
  end cnv;

  -- Function "cnv_u"
  -- Returns the 'unsigned' form of 'num'
  function cnv_u (num : integer; size : positive) return unsigned is
  begin
    return to_unsigned(num, size);
  end cnv_u;

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

  -- Function "extract directional set"
  -- Accepts a gradient pair block
  -- Returns the directional set
  function extract_dir_set (blk : grd_pair_blk) return grd_dir_set is
    variable dir_set : grd_dir_set ;
  begin
    dir_set(0) := blk(4).dir ;

    return dir_set;
  end extract_dir_set;

  -- Function "extract magnitude set"
  -- Accepts a gradient pair block
  -- Returns the magnitude set
  function extract_magn_blk (blk : grd_pair_blk) return grd_magn_blk is
    variable magn_set : grd_magn_blk ;
  begin
    for i in 0 to BLOCK_SIZE-1 loop
      magn_set(i) := blk(i).magn;
    end loop;
    return magn_set;
  end extract_magn_blk;
end canny_header;
