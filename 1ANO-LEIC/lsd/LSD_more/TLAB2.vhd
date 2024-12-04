LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity TLAB2 is
port(W, Y: in STD_LOGIC_VECTOR(3 downto 0);
	  OP: in STD_LOGIC_VECTOR(2 downto 0);
	  CBi: in STD_LOGIC;
	  F: out STD_LOGIC_VECTOR(3 downto 0);
	  BE, GE, Z, OV, CBo: out STD_LOGIC
	  );
end TLAB2;

architecture arq_TLAB2 of TLAB2 is

component LAB4
	port(CBi, OPau: in std_logic;
		  A,B: in std_logic_Vector (3 DOWNTO 0);
		  CBo, OV: out std_logic;
		  R: out std_logic_vector (3 DOWNTO 0)
		  );
end component;

component Logicmodule
 port(A, B: in std_logic_vector (3 downto 0);
      S: in std_logic_vector (1 downto 0);
		Cy: out std_logic;
		R: out std_logic_vector (3 downto 0)
		);
end component;

component MUX6
port(A: in STD_LOGIC_VECTOR(3 downto 0);
	  B: in STD_LOGIC_VECTOR(3 downto 0);
	  S: in std_logic;
	  Y: out STD_LOGIC_VECTOR(3 downto 0)
	  );
end component;

component Flags2
port(iOV, iCB, OP2, Cy: in std_logic;
	  R: in std_logic_vector (3 DOWNTO 0);
	  BE, oGE, Z, oOV, oCB: out std_logic);
end component;

SIGNAL CBx, OVx, Cyx: std_logic;
SIGNAL Ax, Bx, Rx, Yx: std_logic_vector (3 DOWNTO 0);

BEGIN

Yx(0) <= Y(0) and OP(1);
Yx(1) <= Y(1) and OP(1);
Yx(2) <= Y(2) and OP(1);
Yx(3) <= Y(3) and OP(1);


ULAB4: LAB4 port map (
	CBi => CBi,
	OPau => OP(0),
	A => W,
	B => Yx,
	CBo => CBx,
	OV => OVx,
	R => Ax);

ULogicmodule: Logicmodule port map (
	A => W,
	B => Y,
	S(0) => OP(0),
	S(1) => OP(1),
	Cy => Cyx,
	R => Bx);

UMUX6: MUX6 port map (
	A => Bx,
	B => Ax,
	S => OP(2),
	Y => Rx);

UFlags2: Flags2 port map (
	iOV => OVx,
	iCB => CBx,
	OP2 => OP(2),
	Cy => Cyx,
	R => Rx,
	BE => BE,
	oGE => GE,
	Z => Z,
	oOV => OV,
	oCB => CBo);
	
F <= Rx;

end arq_TLAB2;
