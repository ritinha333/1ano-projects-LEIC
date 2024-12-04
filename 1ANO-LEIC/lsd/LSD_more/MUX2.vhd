LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX2 is
port(A1, B1, C1, D1: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end MUX2;

architecture arq_MUX2 of MUX2 is

begin

Y <= (not S0 and not S1 and A1) or (S0 and not S1 and B1) or (not S0 and S1 and C1) or (S0 and S1 and D1);

end arq_MUX2;