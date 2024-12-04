LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX1 is
port(
A : in STD_LOGIC;
B : in STD_LOGIC;
S : in std_logic;
Y : out STD_LOGIC
);
end MUX1;

architecture arq_MUX1 of MUX1 is

begin

Y <= (not S and A) or (S and B);

end arq_MUX1;