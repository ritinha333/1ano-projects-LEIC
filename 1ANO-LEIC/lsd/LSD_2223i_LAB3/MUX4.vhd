LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX4 is
	port(
		A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		S: IN STD_LOGIC;
		Y: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
end MUX4;


architecture teste of MUX4 is

begin
PROCESS (A,B)
BEGIN
	Y(0) <= (not S and B(0)) or (S and A(0));
	Y(1) <= (not S and B(1)) or (S and A(1));
	Y(2) <= (not S and B(2)) or (S and A(2));
	Y(3) <= (not S and B(3)) or (S and A(3));
END PROCESS;
end architecture;

