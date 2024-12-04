LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity XNORL4 is
	port(
		A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		R: OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
end XNORL4;


architecture teste of XNORL4 is

begin
    process (A, B)
	BEGIN

R(0) <= (A(0) AND B(0)) OR (not A(0) and not B(0));
R(1) <= (A(1) AND B(1)) OR (not A(1) and not B(1));
R(2) <= (A(2) AND B(2)) OR (not A(2) and not B(2));
R(3) <= (A(3) AND B(3)) OR (not A(3) and not B(3));

    end process;

end architecture;

