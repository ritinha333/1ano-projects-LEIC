LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_LCD_Controller is 
port(	
	CLK: in std_logic;
	SS: in std_logic;
	SCLK: in std_logic;
	SDX: in std_logic;
	D_out: out std_logic_vector (8 downto 0);
	Wrl: out std_logic;
	R: in std_logic
);
end Serial_LCD_Controller;

architecture ARQ_Serial_LCD_Controller of Serial_LCD_Controller is

component Serial_Receiver is
port(	
	SDX: in std_logic;
	SCLK: in std_logic;
	accept: in std_logic;
	CLK: in std_logic;
	SS: in std_logic;
	R: in std_logic;
	D: out std_logic_vector (8 downto 0);
	DX_val: out std_logic
);
end component;

component LCD_Dispatcher is
port(	
	CLK: in std_logic;
	RESET: in std_logic;
	R: out std_logic;
	CE: out std_logic;
	D_val: in std_logic;
	TC: in std_logic;
	D_in: in std_logic_vector (8 downto 0);
	D_out: out std_logic_vector (8 downto 0);
	Wrl: out std_logic;
	done: out std_logic
);
end component;

component CLKDIV is
generic (div: natural := 100000);
port (
	clk_in: in std_logic;
	clk_out: out std_logic
);
end component;


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
	Clk: in std_logic; 
	Q: out std_logic_vector(3 downto 0) 
);
end component;

signal s_clkdiv, not_clk, s_r, s_CE, s_done, s_D_val, s_tc:std_logic:='0';
signal sq_counter: std_logic_vector(3 downto 0);
signal s_D: std_logic_vector(8 downto 0);

begin

CLK_Inst0: clkDIV generic map (div => 100000) port map (
	clk_in => CLK,
	clk_out => s_clkdiv
);

Serial_ReceiverL_INST0: Serial_Receiver port map(
	SDX => SDX,
	SCLK => SCLK,
	accept => s_done,
	CLK => CLK,
	SS => SS,
	R => R,
	D => s_D,
	DX_val => s_D_val
);

LCD_Dispatcher_INST0: LCD_Dispatcher port map(
	CLK => CLK, -- s_clkdiv????
	D_val => s_D_val,
	TC => s_tc,
	D_in => s_D,
	D_out => D_out,
	Wrl => Wrl,
	done => s_done,
	RESET => R,
	CE => s_CE,
	R => s_r
);

COMPARE4_Inst0: Compare4 port map (
	terminalValue => "1100",
	Q => sq_counter,
	TC => s_tc
);

COUNTER_UP4_Inst0: Counter_UPDown_4 port map (
 	R => s_r,
	DataIn => "0000",
	OP => '0',
	PL => '0',
	CE => s_CE,
	Clk => CLK,
	Q => sq_counter
);

end ARQ_Serial_LCD_Controller;