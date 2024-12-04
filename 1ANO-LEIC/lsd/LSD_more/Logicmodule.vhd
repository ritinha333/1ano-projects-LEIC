library ieee;
use ieee.std_logic_1164.all;

entity Logicmodule is 
 port(A, B: in std_logic_vector (3 downto 0);
      S: in std_logic_vector (1 downto 0);
		Cy: out std_logic;
		R: out std_logic_vector (3 downto 0));
end Logicmodule;

architecture arq_Logicmodule of Logicmodule is

component lsr
 port(A: in std_logic_vector (3 downto 0);
      B: in std_logic_vector (3 downto 0);
		R: out std_logic_vector (3 downto 0));
end component;

component asr
 port(A: in std_logic_vector (3 downto 0);
      B: in std_logic_vector (3 downto 0);
		Cy: out std_logic;
		R: out std_logic_vector (3 downto 0));
end component;

component XNORL4
 port(A, B: in std_logic_vector (3 downto 0);
      R: out std_logic_vector (3 downto 0));
end component;

component ORL4
 port(A, B: in std_logic_vector (3 downto 0);
      R: out std_logic_vector (3 downto 0));
end component;

component MUX5
port(A, B, C, D: in STD_LOGIC_VECTOR(3 DOWNTO 0);
	  S: in STD_LOGIC_VECTOR(1 DOWNTO 0);
	  R: out STD_LOGIC_VECTOR(3 DOWNTO 0));
end component;

signal m0, m1, m2, m3: STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

UORL4: ORL4 port map(
		 A => A,
		 B => B,
		 R => m2
       );

UXNORL4: XNORL4 port map(
		 A => A,
		 B => B,
		 R => m3
       );

Ulsr: lsr port map(
		 A => A,
		 B => B,
		 R => m0
		 );
		
Uasr: asr port map(
		 A => A,
		 B => B,
		 Cy => Cy,
		 R => m1
       );
		
UMUX5: MUX5 port map(
		 A => m0,
		 B => m1,
		 C => m2,
		 D => m3,
		 S => S,
		 R => R
       );
			
end arq_Logicmodule;
