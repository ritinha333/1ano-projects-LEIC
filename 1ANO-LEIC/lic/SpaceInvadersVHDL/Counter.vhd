library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity Counter is
port (
	PL: in std_logic; 										-- Parallel Load;
	CE: in std_logic; 										-- Count Enable;
	CLK: in std_logic;
	R: in std_logic;
	terminalValue: in std_logic_vector(1 downto 0);
	Q: out std_logic_vector(1 downto 0);
	TC: out std_logic 											-- Terminal Count (TC): Indica o fim de contagem. Quando a '1' indica que a contagem chegou ao valor definido por terminalValue.
);
end Counter;

architecture ARCH_Counter of Counter is

component Compare is
port (
	terminalValue: in std_logic_vector(1 downto 0);
	Q: in std_logic_vector(1 downto 0);
	TC: out std_logic
);
end component;

component Counter_UP is
port (
	DataIn: in std_logic_vector(1 downto 0);
	PL: in std_logic;
	RESET: in std_logic;
	CE: in std_logic;   
	Clk: in std_logic; 
	Q: out std_logic_vector(1 downto 0) 
);
end component;

signal sq_counter: std_logic_vector(1 downto 0);

Begin 

COMPARE_Inst0: Compare port map (
	terminalValue => terminalValue,
	Q => sq_counter,
	TC => TC
);

COUNTER_UP_Inst0: Counter_UP port map (
	DataIn => "00",
	RESET => R,
 	PL => PL,
	CE => CE,
	Clk => CLK,
	Q => sq_counter
);

Q <= sq_counter;

end ARCH_Counter;