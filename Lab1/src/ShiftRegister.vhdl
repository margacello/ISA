library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftRegister is
	generic ( N : positive );
	port (
				clk 		: in 		std_logic; 
				rst_n 	: in 		std_logic;
				load 		: in 		std_logic;
				D 			: in 		std_logic;
				Q				: out 	unsigned (N - 2 downto 0)
			);	
end ShiftRegister;

architecture arch of ShiftRegister is
	component Register is
		generic ( N : positive );
		port 	(
						clk 		: in 		std_logic; 
						rst_n 	: in 		std_logic;
						load 		: in 		std_logic;
						D 			: in 		signed ( N - 1 downto 0);
						Q				: out 	signed ( N - 1 downto 0)
					);
	end component Register;
	
	signal sD	: signed ( N - 1 downto 0);
	signal sQ	: signed ( N - 1 downto 0);
	
begin
	
	reg_gen : for I in 0 to N - 1 generate
		reg : Register
		generic map ( N => 1 )
		port map 		(	
									clk		=> clk,
									rst_n	=> rst_n,
									load 	=> load,
									D			=> sD(I downto I),
									Q			=> sQ(I downto I)
								);	
	end generate reg_gen;
	
	sD(0) <= D;
	
	conn : for I in 1 to N - 1 generate
		sD(I) <= sQ(I-1);
		Q(I-1) <= sQ(I-1)
	end generate conn;	
end architecture ; -- arch