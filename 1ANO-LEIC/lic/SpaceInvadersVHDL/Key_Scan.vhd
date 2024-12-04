LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Key_Scan is
port(
	R: in std_logic;
	CLK : in std_logic;
	K_scan: in std_logic_vector(1 downto 0);
	Lines: in std_logic_vector(3 downto 0);
	Collumns: out std_logic_vector(2 downto 0);
	K_press: out std_logic;
	K: out std_logic_vector(3 downto 0)
);
end Key_Scan;

architecture arq_Key_Scan of Key_Scan is

component CLKDIV is
port (
	clk_in: in std_logic;
	clk_out: out std_logic
);
end component;

component reg2bits IS
PORT( 
	CLK : in std_logic;
	RESET : in STD_LOGIC;
	D : IN STD_LOGIC_VECTOR(1 downto 0);
	EN : IN STD_LOGIC;
	Q : out std_logic_VECTOR(1 downto 0)
);
END component;

component PriorityEncoder is
port (
	I: in std_logic_vector(3 downto 0);
	Y: out std_logic_vector(1 downto 0);
	gs: out std_logic
);
end component;

component Decoder
PORT ( 
	S : in std_logic_vector(1 downto 0);
	C : out STD_LOGIC_VECTOR(2 downto 0)
);
end component;

component Counter
PORT (
	R: in std_logic;
	PL: in std_logic; 										-- Parallel Load;
	CE: in std_logic; 										-- Count Enable;
	CLK: in std_logic;
	terminalValue: in std_logic_vector(1 downto 0);
	Q: out std_logic_vector(1 downto 0);
	TC: out std_logic 	
);

end component;

signal s_mux, s_tc: std_logic:='0';
signal sq_counter, reg_output, penc_output: std_logic_vector(1 downto 0);
signal inputPENC: std_logic_vector(3 downto 0);
begin

COUNTER_Inst0: Counter port map (
	R => R,
 	PL => s_tc,
	CE => K_scan(1),
	CLK => CLK,
	TC => s_tc,
	terminalValue => "10",
	Q => sq_counter
);

inputPENC <= not(Lines);
PENC_INST0: PriorityEncoder port map (
	I => inputPENC,
	Y => penc_output,
	gs => K_press
);

REG_INST0: reg2bits port map (
	CLK => K_scan(0),
	RESET => R,
	D => penc_output,
	EN => '1',
	Q => reg_output
);

DECODER_INST0: Decoder port map(
	S(0) => sq_counter(0),
	S(1) => sq_counter(1),
	C => Collumns
);

K(3) <= sq_counter(1);
K(2) <= sq_counter(0);
K(1) <= reg_output(1);
K(0) <= reg_output(0);

end arq_Key_Scan;