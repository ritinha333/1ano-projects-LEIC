LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity Shift_Register_7bits is
port (
Sin 	: in std_logic;	--Serial in
S_PL 	: in std_logic; -- Shift/Write
enableShift	: in std_logic;
clr 	: in std_logic;
clk 	: in std_logic;
D		: in std_logic_vector(6 downto 0);
Sout 	: out std_logic;
Q 		: out std_logic_vector(6 downto 0)
);
end Shift_Register_7bits;

architecture ARQ_Shift_Register_7bits OF Shift_Register_7bits IS

component FFD
PORT( 
CLK : in std_logic;
RESET : in STD_LOGIC;
SET : in std_logic;
D : IN STD_LOGIC;
EN : IN STD_LOGIC;
Q : out std_logic);
end component;

signal s_y0, s_y1, s_y2, s_y3, s_y4, s_y5, s_y6, s_y7, s_y8: std_logic;
signal s_q0, s_q1, s_q2, s_q3, s_q4, s_q5, s_q6: std_logic;		--, s_q7, s_q8 : std_logic;

BEGIN

U0: FFD port map(CLK => clk, reset => clr, set => '0', D => Sin, EN => enableShift, Q => s_q6);
U1: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q6, EN => enableShift, Q => s_q5);
U2: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q5, EN => enableShift, Q => s_q4);
U3: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q4, EN => enableShift, Q => s_q3);
U4: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q3, EN => enableShift, Q => s_q2);
U5: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q2, EN => enableShift, Q => s_q1);
U6: FFD port map(CLK => clk, reset => clr, set => '0', D => s_q1, EN => enableShift, Q => s_q0);




Q(0) <= s_q0;
Q(1) <= s_q1;
Q(2) <= s_q2;
Q(3) <= s_q3;
Q(4) <= s_q4;
Q(5) <= s_q5;
Q(6) <= s_q6;

Sout <= s_q0;

end ARQ_Shift_Register_7bits;