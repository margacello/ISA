library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier is 
	generic( N : positive := 16);
	port ( 
			A :		in 	signed (N - 1 	downto 0);
			B :		in 	signed (N - 1 	downto 0);
			C :		out signed (2*N - 1 downto 0)

			);
end Multiplier;

architecture arch of Multiplier is

begin
	C <= A * B;

end architecture ;