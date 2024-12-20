LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_Score_Controller is 
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

end Serial_Score_Controller;
 
architecture ARQ_Serial_Score_Controller of Serial_Score_Controller is

component Serial_Receiver_7bits is
port(	SDX: in std_logic;
		SCLK: in std_logic;
		accept: in std_logic;
		CLK: in std_logic;
		SS: in std_logic;
		R: in std_logic;
		D: out std_logic_vector (6 downto 0);
		DX_val: out std_logic
);
end component;

component Score_Dispatcher is 
port(	
		CLK: in std_logic;
		RESET: in std_logic;
		R: out std_logic;
		D_val: in std_logic;
		D_in: in std_logic_vector (6 downto 0);
		D_out: out std_logic_vector (6 downto 0);
		Wrl: out std_logic;
		done: out std_logic
);
end component;

component UsbPort
port(	inputPort:  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		outputPort :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;

component scoreDisplay is
port(	set	: in std_logic;
		cmd	: in std_logic_vector(2 downto 0);
		data	: in std_logic_vector(3 downto 0);
		HEX0	: out std_logic_vector(7 downto 0);
		HEX1	: out std_logic_vector(7 downto 0);
		HEX2	: out std_logic_vector(7 downto 0);
		HEX3	: out std_logic_vector(7 downto 0);
		HEX4	: out std_logic_vector(7 downto 0);
		HEX5	: out std_logic_vector(7 downto 0)
		);
end component;

signal s_r, s_CE, s_done, s_D_val, s_tc, s_sdx, s_clk, s_ss, s_clear, s_en, s_wrd : std_logic;
signal s_D_out, s_D_aux: std_logic_vector(6 downto 0);

begin

Wrl <= s_D_val;

SCORE_DISPLAY_INST0: scoreDisplay port map(
	set => s_wrd,
	cmd(0) => s_D_out(4),
	cmd(1) => s_D_out(5),
	cmd(2) => s_D_out(6),
	data(0) => s_D_out(0),
	data(1) => s_D_out(1),
	data(2) => s_D_out(2),
	data(3) => s_D_out(3),
	HEX0 => HEX0,
	HEX1 => HEX1,
	HEX2 => HEX2,
	HEX3 => HEX3,
	HEX4 => HEX4,
	HEX5 => HEX5
);

--D(0) <= s_sdx;
--D(1) <= s_clk;
--D(2) <= s_ss;

SERIAL_RECEIVER_7BITS_INST0: Serial_Receiver_7bits port map(
	SDX => SDX,
	SCLK => SCLK,
	accept => s_done,
	CLK => CLK,
	SS => SS,
	R => R,
	D => s_D_aux,
	DX_val => s_D_val
);

SCORE_DISPATCHER_INST0: Score_Dispatcher port map(
	CLK => CLK,
	D_val => s_D_val,
	D_in => s_D_aux,
	D_out => s_D_out,
	Wrl => s_wrd,
	done => s_done,
	RESET => R,
	R => s_r
);

-- D_out <= s_D_out;

end ARQ_Serial_Score_Controller;