LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX4 is
port(A3, B3, C3, D3: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end MUX4;

architecture arq_MUX4 of MUX4 is

begin

Y <= (not S0 and not S1 and A3) or (S0 and not S1 and B3) or (not S0 and S1 and C3) or (S0 and S1 and D3);

end arq_MUX4;