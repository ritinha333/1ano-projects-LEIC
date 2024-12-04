library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Counter_UPDown_4 is
port (
OP: in std_logic;
DataIn: in std_logic_vector(3 downto 0);
PL: in std_logic;
R: in std_logic;
CE: in std_logic;   
Clk: in std_logic; 
Q: out std_logic_vector(3 downto 0) 
);
end Counter_UPDown_4;
  
architecture ARCH_Counter_UPDown4 of Counter_UPDown_4 is

component ADDER4 is
port (
A: in std_logic_vector(3 downto 0);
B: in std_logic_vector(3 downto 0);
C0: in std_logic;
S: out std_logic_vector(3 downto 0);
C4: out std_logic
);
end component;

component reg is
port (
CLK : in std_logic;
RESET : in STD_LOGIC; 
D : IN STD_LOGIC_VECTOR(3 downto 0);
EN : IN STD_LOGIC;
Q : out std_logic_VECTOR(3 downto 0)
);
end component;


component MUX41 is
port (
A : in STD_LOGIC_VECTOR(3 downto 0);
B : in STD_LOGIC_VECTOR(3 downto 0);
S : in std_logic;
Y : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

signal s_c0: std_logic;
signal s_B, s_out_reg, s_out_adder: std_logic_vector(3 downto 0);
signal sb_mux, sy_mux: std_logic_vector(3 downto 0);

Begin 

s_B(3) <= OP;
s_B(2) <= OP;
s_B(1) <= OP;
s_B(0) <= OP;

s_c0 <= '1' xor OP;

ADDER4_Inst0: ADDER4 port map (
	A => s_out_reg,
	B => s_B,
	C0 => s_c0,
	C4 => open,
	S => s_out_adder
);


MUX41_Inst0: MUX41 port map (
	A => s_out_adder,
	B => DataIn,
	S => PL,
	Y => sy_mux
);

REGISTER_Inst0: reg port map (
	CLK => Clk,
	RESET => R,
	D => sy_mux,
	EN => CE,
	Q => s_out_reg
);

Q <= s_out_reg;

end ARCH_Counter_UPDown4;