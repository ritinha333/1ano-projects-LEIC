LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Output_Buffer is
port(
RESET: in std_logic;
CLK : in std_logic;
Load: in std_logic;
ACK: in std_logic;
D: in std_logic_vector(3 downto 0);
Q: out std_logic_vector(3 downto 0);
OB_free: out std_logic;
D_val: out std_logic
);
end Output_Buffer;

architecture arq_Output_Buffer of Output_Buffer is

component reg is
port (
CLK : in std_logic;
RESET : in STD_LOGIC; 
D : IN STD_LOGIC_VECTOR(3 downto 0);
EN : IN STD_LOGIC;
Q : out std_logic_VECTOR(3 downto 0)
);
end component;

component Buffer_Control is
port (
RESET: in std_logic;
CLK : in std_logic;
Load: in std_logic;
ACK: in std_logic;
W_reg: out std_logic;
OB_free: out std_logic;
D_val: out std_logic
);
end component;

signal s_w_reg: std_logic;

begin

REGISTER_Inst0: reg port map (
	CLK => s_w_reg,
	RESET => RESET,
	D => D,
	EN => '1',
	Q => Q
);

BUFFER_CONTROL_INST0: Buffer_Control port map (
	RESET => RESET, 
	CLK => CLK, 
	Load => Load, 
	ACK => ACK, 
	W_reg => s_w_reg, 
	OB_free => OB_free,
	D_val => D_val
);

end arq_Output_Buffer;