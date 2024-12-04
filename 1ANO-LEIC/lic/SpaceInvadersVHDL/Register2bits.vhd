LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg2bits IS
PORT( 
	CLK : in std_logic;
	RESET : in STD_LOGIC;
	D : IN STD_LOGIC_VECTOR(1 downto 0);
	EN : IN STD_LOGIC;
	Q : out std_logic_VECTOR(1 downto 0)
);
END reg2bits;

ARCHITECTURE logicFunction OF reg2bits IS

component FFD
PORT(
	CLK : in std_logic;
	RESET : in STD_LOGIC;
	SET : in std_logic;
	D : IN STD_LOGIC;
	EN : IN STD_LOGIC;
	Q : out std_logic
);
end component;

BEGIN

U0: FFD port map(CLK => clk, reset => reset, set => '0', D => D(0), EN => EN, Q => Q(0));
U1: FFD port map(CLK => clk, reset => reset, set => '0', D => D(1), EN => EN, Q => Q(1));

END LogicFunction;