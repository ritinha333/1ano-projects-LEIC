LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity ORL4 is
port(A : in STD_LOGIC_VECTOR(3 downto 0);
B : in STD_LOGIC_VECTOR(3 downto 0);
R : out STD_LOGIC_VECTOR(3 downto 0)
);

end ORL4;
architecture arq_orl4 of ORL4 is
begin
R(0) <= A(0) or B(0);
R(1) <= A(1) or B(1);
R(2) <= A(2) or B(2);
R(3) <= A(3) or B(3);
end arq_orl4;