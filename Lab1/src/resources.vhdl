library ieee;
use ieee.std_logic_1164.all;

package resources is
  -- constants
  constant BIT_WIDTH  : integer := 13;
  constant ORDER      : integer :=  2;
  constant N_ADD      : integer :=  4;
  constant N_MULT     : integer :=  5;

  -- type definitions
  type sBIT_WIDTH_array_t     is array (natural range <>) of signed (BIT_WIDTH - 1  downto 0);
  type sN_MULT_array_t        is array (natural range <>) of signed (N_MULT - 1     downto 0);
  type sN_ADD_array_t         is array (natural range <>) of signed (N_ADD - 1      downto 0);
  type sORDER_array_t         is array (natural range <>) of signed (ORDER - 1      downto 0);

end package resources;

package body resources is
end package body resources;
