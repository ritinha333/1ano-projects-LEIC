library ieee; 
 use ieee.std_logic_1164.all; 
 
 entity Adder is
	port(
 A, B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
 C0: in STD_LOGIC;
 S: out STD_LOGIC_VECTOR (3 DOWNTO 0);
 C4: out STD_LOGIC
 );
 end Adder;
 
 architecture arq_Adder of Adder is
 
 component FAdder
	Port(
 A, B, Ci: in STD_LOGIC;
 S, CO: out STD_LOGIC
 );
 end component;
 
 SIGNAL c1, c2, c3: STD_LOGIC;
 
 BEGIN 
 
 UFAdder1: FAdder port map(
	A => A(0),
	B => B(0),
	Ci => C0,
	CO => c1,
	S => S(0));

 UFAdder2: FAdder port map(
 	A => A(1),
	B => B(1),
	Ci => c1,
	CO => c2,
	S => S(1));
	
 UFAdder3: FAdder port map(
	A => A(2),
	B => B(2),
	Ci => c2,
	CO => c3,
	S => S(2));
	
 UFAdder4: FAdder port map(
	A => A(3),
	B => B(3),
	Ci => c3,
	CO => C4,
	S => S(3));
	
 end arq_Adder;