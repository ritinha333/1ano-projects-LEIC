LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX21 is
port(
A : in STD_LOGIC_VECTOR(1 downto 0);
B : in STD_LOGIC_VECTOR(1 downto 0);
S : in std_logic;
Y : out STD_LOGIC_VECTOR(1 downto 0)
);
end MUX21;

architecture arq_MUX21 of MUX21 is

begin

Y(0) <= (not S and A(0)) or (S and B(0));
Y(1) <= (not S and A(1)) or (S and B(1));

end arq_MUX21;