LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX5 is
port(A, B, C, D: in STD_LOGIC_VECTOR(3 DOWNTO 0);
	  S: in STD_LOGIC_VECTOR(1 DOWNTO 0);
	  R: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end MUX5;

architecture arq_MUX5 of MUX5 is

component MUX1
port(A0, B0, C0, D0: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end component;

component MUX2
port(A1, B1, C1, D1: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end component;

component MUX3
port(A2, B2, C2, D2: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end component;

component MUX4
port(A3, B3, C3, D3: in STD_LOGIC;
	  S0, S1: in std_logic;
	  Y: out STD_LOGIC);
end component;

BEGIN

UMUX1: MUX1 port map(
		 A0 => A(0),
		 B0 => B(0),
		 C0 => C(0),
		 D0 => D(0),
		 S0 => S(0),
		 S1 => S(1),
		 Y => R(0));
		 
UMUX2: MUX2 port map(
		 A1 => A(1),
		 B1 => B(1),
		 C1 => C(1),
		 D1 => D(1),
		 S0 => S(0),
		 S1 => S(1),
		 Y => R(1)
		 );

UMUX3: MUX3 port map(
		 A2 => A(2),
		 B2 => B(2),
		 C2 => C(2),
		 D2 => D(2),
		 S0 => S(0),
		 S1 => S(1),
		 Y => R(2));
		
UMUX4: MUX4 port map(
		 A3 => A(3),
		 B3 => B(3),
		 C3 => C(3),
		 D3 => D(3),
		 S0 => S(0),
		 S1 => S(1),
		 Y => R(3));

end arq_MUX5;