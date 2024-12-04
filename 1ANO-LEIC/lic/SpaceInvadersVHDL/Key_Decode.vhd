LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Key_Decode is
port(
R: in std_logic;
CLK : in std_logic;
K_ack: in std_logic;
Lines: in std_logic_vector(3 downto 0);
Collumns: out std_logic_vector(2 downto 0);
K_val: out std_logic;
K: out std_logic_vector(3 downto 0)
);
end Key_Decode;

architecture arq_Key_Decode of Key_Decode is

component CLKDIV is
generic (div: natural := 50000000);
port (
	clk_in: in std_logic;
	clk_out: out std_logic
);
end component;

component Key_Scan
PORT ( 
CLK : in std_logic;
R: in std_logic;
K_scan: in std_logic_Vector(1 downto 0);
Lines: in std_logic_vector(3 downto 0);
Collumns: out std_logic_vector(2 downto 0);
K_press: out std_logic;
K: out std_logic_vector(3 downto 0)
);
end component;

component Key_Control
PORT (
RESET: in std_logic;
CLK : in std_logic;
K_press: in std_logic;
K_ack: in std_logic;
K_val: out std_logic;
K_scan: out std_logic_vector(1 downto 0)
);
end component;

signal s_clkdiv, sk_press, s_notclk: std_logic; 
signal sk_scan: std_logic_vector(1 downto 0);

begin

CLK_Inst0: clkDIV generic map (div => 100000) port map (
	clk_in => CLK,
	clk_out => s_clkdiv
);

KEY_SCAN_INST0: Key_Scan port map(
	CLK => s_clkdiv,
	K_scan => sk_scan,
	Lines => Lines,
	Collumns => Collumns,
	K_press => sk_press,
	K => K,
	R => R
);

s_notclk <= not(s_clkdiv);
KEY_Control_INST0: Key_Control port map(
	RESET => R,
	CLK => s_notclk,
	K_press => sk_press,
	K_ack => K_ack,
	K_val => K_val,
	K_scan => sk_scan
);

end arq_Key_Decode;