LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity XNORL4 is
port(A : in STD_LOGIC_VECTOR(3 downto 0);
B : in STD_LOGIC_VECTOR(3 downto 0);
R : out STD_LOGIC_VECTOR(3 downto 0)
);
end XNORL4;

architecture arq_xnorl4 of XNORL4 is
begin
R(0) <= not(A(0) xor B(0));
R(1) <= not(A(1) xor B(1));
R(2) <= not(A(2) xor B(2));
R(3) <= not(A(3) xor B(3));
end arq_xnorl4;