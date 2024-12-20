LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_Receiver_7bits is 
port(	SDX: in std_logic;
		SCLK: in std_logic;
		accept: in std_logic;
		CLK: in std_logic;
		SS: in std_logic;
		R: in std_logic;
		D: out std_logic_vector (6 downto 0);
		DX_val: out std_logic
);

end Serial_Receiver_7bits;

 
architecture ARQ_Serial_Receiver_7bits of Serial_Receiver_7bits is

component Serial_Control is
port(	LCDsel: in std_logic;
		RESET: in std_logic;
		accept: in std_logic;
		pFlag: in std_logic;
		dFlag: in std_logic;
		RXerror: in std_logic;
		wr: out std_logic;
		init: out std_logic;
		DXval: out std_logic;
		CLK: in std_logic
);

end component;


component Parity_Check is
port( data: in std_logic;
		init: in std_logic;
		clk: in std_logic;
		err: out std_logic
);

end component;


component Shift_Register_7bits is 
port (Sin: in std_logic;
		S_PL: in std_logic; -- Shift/Write
		enableShift: in std_logic;
		clr: in std_logic;
		clk: in std_logic;
		D: in std_logic_vector(6 downto 0);
		Sout: out std_logic;
		Q: out std_logic_vector(6 downto 0)
);
end component;

component Counter_UPDown_4 
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


component Compare4 
port (
	terminalValue: in std_logic_vector(3 downto 0);
	Q: in std_logic_vector(3 downto 0);
	TC: out std_logic
);
end component;

signal s_wr, s_err, s_init, s_accept, s_sdx, s_clk, s_ss: std_logic;
signal s_tc, s_CE, s_PL, s_out, clr, s_dflag, s_pflag : std_logic;
signal s_Q, sq_counter: std_logic_vector (3 downto 0);

begin

SERIAL_CONTROL_INST0: Serial_Control port map(
	LCDsel => SS,
	CLK => CLK,
	RESET => R,
	accept => accept,
	pFlag => s_pflag, 
	dFlag => s_dflag,
	RXerror => s_err,
	wr => s_wr,
	init => s_init,
	DXval => DX_val
);

PARITY_CHECK_INS0: Parity_Check port map(
	data => SDX,
	init => s_init,
	clk => SCLK,
	err => s_err
);

SHIFT_REGISTER_7BITS_INST0: Shift_Register_7bits port map(
	Sin => SDX,
	clr => R,
	enableShift => s_wr,
	clk => SCLK,
	D => "0000000",
	S_PL => '0' ,
	Sout => s_out,
	Q => D
);

COMPARE_Inst0: Compare4 port map (
	terminalValue => "0111",
	Q => sq_counter,
	TC => s_dflag
);

COMPARE_Inst1: Compare4 port map(
	terminalValue => "1000",
	Q => sq_counter,
	TC => s_pflag
);

COUNTER_INST0: Counter_UPDown_4 port map(
	OP => '0',
	DataIn => "0000",
	PL => '0',
	CE => '1',
	R => s_init, 
	Clk => SCLK,
	Q => sq_counter
);
end ARQ_Serial_Receiver_7bits;