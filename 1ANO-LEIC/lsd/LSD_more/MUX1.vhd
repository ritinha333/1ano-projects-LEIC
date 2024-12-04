LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX1 is
port(A0, B0, C0, D0: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end MUX1;

architecture arq_MUX1 of MUX1 is

begin

Y <= (not S0 and not S1 and A0) or (S0 and not S1 and B0) or (not S0 and S1 and C0) or (S0 and S1 and D0);

end arq_MUX1;