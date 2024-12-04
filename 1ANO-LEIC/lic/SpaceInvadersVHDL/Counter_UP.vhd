library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity Counter_Up is
port (
DataIn: in std_logic_vector(1 downto 0);
PL: in std_logic;
CE: in std_logic;   
Clk: in std_logic;
RESET: in std_logic;
Q: out std_logic_vector(1 downto 0) 
);
end Counter_UP;
  
architecture ARCH_Counter_UP of Counter_UP is

component ADDER is
port (
A: in std_logic_vector(1 downto 0);
B: in std_logic_vector(1 downto 0);
C0: in std_logic;
S: out std_logic_vector(1 downto 0);
C4: out std_logic
);
end component;

component reg2bits is
port (
CLK : in std_logic;
RESET : in STD_LOGIC;
D : IN STD_LOGIC_VECTOR(1 downto 0);
EN : IN STD_LOGIC;
Q : out std_logic_VECTOR(1 downto 0)
);
end component;

component MUX21 is
port (
A : in STD_LOGIC_VECTOR(1 downto 0);
B : in STD_LOGIC_VECTOR(1 downto 0);
S : in std_logic;
Y : out STD_LOGIC_VECTOR(1 downto 0)
);
end component;

signal sb_mux, sy_mux, s_out_reg: std_logic_vector(1 downto 0);

Begin 

MUX21_Inst0: MUX21 port map (
	A => sb_mux,
	B => DataIn,
	S => PL,
	Y => sy_mux
);

REGISTER_Inst0: reg2bits port map (
	CLK => Clk,
	RESET => RESET,
	D => sy_mux,
	EN => CE,
	Q => s_out_reg
);

ADDER_Inst0: ADDER port map (
	A => s_out_reg,
	B => "00",
	C0 => '1',
	C4 => open,
	S => sb_mux
);

Q <= s_out_reg;

end ARCH_Counter_UP;