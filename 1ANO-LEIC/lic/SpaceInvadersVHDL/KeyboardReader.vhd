LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyboardReader is
port(
R: in std_logic; --Reset
CLK : in std_logic;
ACK: in std_logic;
Lines: in std_logic_vector(3 downto 0);
Collumns: out std_logic_vector(2 downto 0);
D_val: out std_logic;
D: out std_logic_vector(3 downto 0)
);
end KeyboardReader;

architecture arq_KeyboardReader of KeyboardReader is

component Key_Decode
PORT (
R: in std_logic; 
CLK : in std_logic;
K_ack: in std_logic;
Lines: in std_logic_vector(3 downto 0);
Collumns: out std_logic_vector(2 downto 0);
K_val: out std_logic;
K: out std_logic_vector(3 downto 0)
);
end component;

component Output_Buffer is
port (
RESET: in std_logic;
CLK : in std_logic;
Load: in std_logic;
ACK: in std_logic;
D: in std_logic_vector(3 downto 0);
Q: out std_logic_vector(3 downto 0);
OB_free: out std_logic;
D_val: out std_logic
);
end component;

component RingBuffer is
port(
	R: in std_logic;
	CLK : in std_logic;
	D: in std_logic_vector(3 downto 0);
	DAV: in std_logic;
	CTS: in std_logic;
	DAC: out std_logic;
	Wreg: out std_logic;
	Q: out std_logic_vector(3 downto 0)
);
end component;

signal s_k_ack, s_DAV, s_CTS, s_load, sD_val, s_ack: std_logic;
signal s_D_RB, s_D_OB : std_logic_vector(3 downto 0);

begin

KEY_Decode_INST0: Key_Decode port map(
	R => R,
	CLK => CLK,
	K_ack => s_k_ack,
	Lines => Lines,
	Collumns => Collumns,
	K_val => s_DAV,
	K => s_D_RB
);

RING_BUFFER_INST0: RingBuffer port map(
	R => R,
	CLK => CLK,
	D => s_D_RB,
	DAV => s_DAV,
	CTS => s_CTS,
	DAC => s_k_ack,
	Wreg	=> s_load,
	Q => s_D_OB
);

OUTPUT_BUFFER_INST0: Output_Buffer port map(
	RESET => R,
	CLK => CLK,
	Load => s_load,
	ACK => ACK,
	D => s_D_OB,
	Q => D,
	OB_free => s_CTS,
	D_val => D_val
);

end arq_KeyboardReader;