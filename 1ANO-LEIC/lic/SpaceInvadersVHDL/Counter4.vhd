library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Counter4 is
port (
	OP: in std_logic;
	PL: in std_logic; 										-- Parallel Load;
	CE: in std_logic; 										-- Count Enable;
	CLK: in std_logic;
	R: in std_logic;
	terminalValue: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0);
	TC: out std_logic 											-- Terminal Count (TC): Indica o fim de contagem. Quando a '1' indica que a contagem chegou ao valor definido por terminalValue.
);
end Counter4;


architecture ARCH_Counter4 of Counter4 is

component Compare4 is
port (
	terminalValue: in std_logic_vector(3 downto 0);
	Q: in std_logic_vector(3 downto 0);
	TC: out std_logic
);
end component;

component Counter_UPDown_4 is
port (
OP: in std_logic;
DataIn: in std_logic_vector(3 downto 0);
PL: in std_logic;
R: in std_logic;
CE: in std_logic;   
CLK: in std_logic; 
Q: out std_logic_vector(3 downto 0) 
);
end component;

signal sq_counter: std_logic_vector(3 downto 0);

Begin

COMPARE_Inst0: Compare4 port map (
	terminalValue => terminalValue,
	Q => sq_counter,
	TC => TC
);

COUNTER_UP_Inst0: Counter_UPDown_4 port map (
	OP => OP,
	DataIn => "0000",
	R => R,
 	PL => PL,
	CE => CE,
	Clk => CLK,
	Q => sq_counter
);

Q <= sq_counter;

end ARCH_Counter4;