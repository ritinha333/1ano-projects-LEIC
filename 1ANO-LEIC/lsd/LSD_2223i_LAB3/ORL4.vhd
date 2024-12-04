LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity ORL4 is
	port(
		A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		R: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
end ORL4;

architecture teste of ORL4 is


begin

R(0) <= A(0) OR B(0);
R(1) <= A(1) OR B(1);
R(2) <= A(2) OR B(2);
R(3) <= A(3) OR B(3);

end architecture;

