library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is 
	generic( N : positive );
	port 	(
					sel		: in	std_logic;

					A 		: in 	signed ( N - 1 	downto 0 );
					B 		: in 	signed ( N - 1 	downto 0 );
					C 		: out signed ( N - 1 	downto 0 )
				);
end Adder;

architecture arch of Adder is
	signal op1_ca2		: signed ( N - 1 	downto 0 );
	signal op2_ca2		: signed ( N - 1	downto 0 );
	signal res 				: signed ( N - 1	downto 0 );
	
	signal zeros_N_1 		: signed ( N - 2 	downto 0 ) := (others => '0');
	signal ones_N_1			: signed ( N - 2 	downto 0 ) := (others => '1');
begin
			
	op1_ca2 <= A;
	
	-- perform subtraction: change sign (CA2) of second operand
	op2_ca2 <= B when ( sel = '1' ) else -B;
	
	-- check for overflow when adding 2 positive numbers or 2 negative numbers
	res <= '1' & zeros_N_1 	when ((op1_ca2 ( N - 1 ) = '1') and (op2_ca2 ( N - 1) = '1') and ( res ( N - 1 ) = '0' )) else
				 '0' & ones_N_1		when ((op1_ca2 ( N - 1 ) = '0') and (op2_ca2 ( N - 1) = '0') and ( res ( N - 1 ) = '1' )) else 
					op1_ca2 + op2_ca2;
	
	C <= res;
	
end architecture ;
