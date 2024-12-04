LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity LAB4 is
	port(CBi, OPau: in std_logic;
		  A,B: in std_logic_Vector (3 DOWNTO 0);
		  CBo, OV: out std_logic;
		  R: out std_logic_vector (3 DOWNTO 0));
		  
end LAB4;

architecture arq_LAB4 of LAB4 is
 
 component AdderSubtractor
port(A, B: in STD_LOGIC_VECTOR (3 DOWNTO 0);
	  CBi, OPau: in STD_LOGIC;
	  R: out STD_LOGIC_VECTOR (3 DOWNTO 0);
	  iCBo: out STD_LOGIC);
end component;

component Flags
   port(A, B, iCBo, R: in std_logic;  
		  OV, oCBo: out std_logic);
end component;

SIGNAL iCBox, bx: std_logic;
SIGNAL S: std_logic_vector (3 DOWNTO 0);
BEGIN

bx <= B(3) xor OPau;


UAddSub: AdderSubtractor port map(
	A => A,
	B => B,
	R => S,
	CBi => CBi,
	OPau => OPau,
	iCBo => iCBox);

UFlags: Flags port map(
	A => A(3),
	B => bx,
	R => S(3),
	iCBo => iCBox,
	oCBo => CBo,
	OV => OV);
	
R <= S;

end arq_LAB4;
