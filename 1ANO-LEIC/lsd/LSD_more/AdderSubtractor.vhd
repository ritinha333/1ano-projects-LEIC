library ieee; 
 use ieee.std_logic_1164.all; 
 
 entity addersubtractor is
	port(
		A, B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
		CBi, OPau: in STD_LOGIC;
		R: out STD_LOGIC_VECTOR (3 DOWNTO 0);
		iCBo: out STD_LOGIC
		);
 end addersubtractor;

 architecture arq_addersubtractor of addersubtractor is

 component Adder
	Port(
	A, B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
	C0: in STD_LOGIC;
	S: out STD_LOGIC_VECTOR (3 DOWNTO 0);
	C4: out STD_LOGIC
	);
	
 end component;	

 SIGNAL x, cx: STD_LOGIC;
 SIGNAL bx: STD_LOGIC_VECTOR (3 DOWNTO 0);
 
 BEGIN
 
	 bx(0) <= B(0) xor OPau;
	 bx(1) <= B(1) xor OPau;
	 bx(2) <= B(2) xor OPau;
	 bx(3) <= B(3) xor OPau;
	 cx <= CBi xor OPau;
	
 UAdder: Adder port map(
	A => A,
	B => bx,
	C4 => x,
	C0 => cx,
	S => R);
	
iCBo <= x xor OPau;

end arq_addersubtractor;