LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX3 is
port(A2, B2, C2, D2: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end MUX3;

architecture arq_MUX3 of MUX3 is

begin

Y <= (not S0 and not S1 and A2) or (S0 and not S1 and B2) or (not S0 and S1 and C2) or (S0 and S1 and D2);

end arq_MUX3;