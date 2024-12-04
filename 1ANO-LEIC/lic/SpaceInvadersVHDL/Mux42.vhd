LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX42 is
port(
K : in STD_LOGIC_VECTOR(3 downto 0);
S : in std_logic_vector(1 downto 0);
Y : out STD_LOGIC
);
end MUX42;

architecture arq_MUX42 of MUX42 is

begin

Y <= 	(
		((not S(1)) and (not S(0)) and K(0)) 	or 
		((not S(1)) and S(0) and K(1)) 			or 
		(S(1) and (not S(0)) and K(2)) 			or 
		(S(1) and S(0) and K(3))
		);

end arq_MUX42;