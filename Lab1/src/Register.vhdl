library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register is
	generic ( N : positive );
	port 	(
					clk 		: in 	std_logic; 
					rst_n 	: in 	std_logic;
					load 		: in 	std_logic;
					D 			: in 	signed ( N - 1 downto 0);
					Q				: out signed ( N - 1 downto 0)
				);

end RegisterN;

architecture arch of RegisterN is

begin

	reg : process( clk, rst_n )
	begin
		if ( rst_n = '0' ) then 
			Q <= ( others => '0' );
		elsif ( clk'event and clk = '1' ) then
			if ( load = '1' ) then
				Q <= D;
			end if;
		end if;
	end process;
end architecture ; -- arch