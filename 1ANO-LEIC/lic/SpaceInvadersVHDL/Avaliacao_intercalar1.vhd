LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY avaliacao_intercalar1 IS
PORT( 
	R: in std_logic; --Reset
	CLK : in std_logic;
	Lines: in std_logic_vector(3 downto 0);
	Collumns: out std_logic_vector(2 downto 0);
	D: out std_logic_vector(8 downto 0);
	Wrl: out std_logic;
	-- USBPort output (simulador)
	--SDX: in std_logic;
	--SS: in std_logic;
	--SCLK: in std_logic;
	--SACK: in std_logic;
	--------
	EN: out std_logic;
	HEX0: out std_logic_vector(7 downto 0);
	HEX1: out std_logic_vector(7 downto 0);
	HEX2: out std_logic_vector(7 downto 0);
	HEX3: out std_logic_vector(7 downto 0);
	HEX4: out std_logic_vector(7 downto 0);
	HEX5: out std_logic_vector(7 downto 0)
);
END avaliacao_intercalar1;

ARCHITECTURE logicFunction OF avaliacao_intercalar1 IS

component KeyboardReader
port(
	R: in std_logic; --Reset
	CLK : in std_logic;
	ACK: in std_logic;
	Lines: in std_logic_vector(3 downto 0);
	Collumns: out std_logic_vector(2 downto 0);
	D_val: out std_logic;
	D: out std_logic_vector(3 downto 0)
);
end component;

component UsbPort
port(
	inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
	outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;

component Serial_LCD_Controller is 
port(	
	CLK: in std_logic;
	SS: in std_logic;
	SCLK: in std_logic;
	SDX: in std_logic;
	D_out: out std_logic_vector (8 downto 0);
	Wrl: out std_logic;
	R: in std_logic
);
end component;

component Serial_Score_Controller is 
port(	
	R: in std_logic;
	CLK: in std_logic;
	SS: in std_logic;
	SCLK: in std_logic;
	SDX: in std_logic;
--	D_out: out std_logic_vector (6 downto 0);
	Wrl: out std_logic;
--	D: out std_logic_vector (3 downto 0)
	HEX0: out std_logic_vector(7 downto 0);
	HEX1: out std_logic_vector(7 downto 0);
	HEX2: out std_logic_vector(7 downto 0);
	HEX3: out std_logic_vector(7 downto 0);
	HEX4: out std_logic_vector(7 downto 0);
	HEX5: out std_logic_vector(7 downto 0)
);
end component;

signal s_sdx, s_ss_score, s_ss_lcd, s_clk, s_val, s_ack: std_logic;
signal s_D, s_D_low_in, s_D_low_out : std_logic_vector(3 downto 0);

BEGIN

KEYBOARD_READER_INST0: KeyboardReader port map(
	R => R,
	CLK => CLK,
	ACK => s_ack,
	Lines => Lines,
	Collumns => Collumns, 
	D_val => s_val,
	D => s_D
);

USB_PORT_INST0: UsbPort port map(
	inputPort(3 downto 0) => s_D,
	inputPort(4) => s_val,
	inputPort(5) => '0',
	inputPort(6) => '0',
	inputPort(7) => '0',

	outputPort(0) => s_ss_lcd,
	outputPort(1) => s_ss_score,
	outputPort(3) => s_sdx,
	outputPort(4) => s_clk,
	outputPort(7) => s_ack
);

SLCDC_INST0: Serial_LCD_Controller port map(
	CLK => CLK,
	SS  => s_ss_lcd,
	SCLK => s_clk,
	SDX => s_sdx,
	D_out => D,
	Wrl => EN,
	R => R
);

SSC_INST0: Serial_Score_Controller port map(
	R => R,
	CLK => CLK,
	SS => s_ss_score,
	SCLK => s_clk,
	SDX => s_sdx,
	Wrl => Wrl,
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5
);

END LogicFunction;