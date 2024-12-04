LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity LCD_Dispatcher_tb is
end LCD_Dispatcher_tb;

architecture behavioral of LCD_Dispatcher_tb is

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

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal CLK_tb: std_logic;
signal RESET_tb: std_logic;
signal R_tb: std_logic;
signal CE_tb: std_logic;
signal D_val_tb: std_logic;
signal TC_tb: std_logic;
signal D_in_tb: std_logic_vector (8 downto 0);
signal D_out_tb: std_logic_vector (8 downto 0);
signal Wrl_tb: std_logic;
signal done_tb: std_logic;

begin

---Unit Under Test
UUT: LCD_Dispatcher 
port map(CLK => CLK_tb,
			RESET => RESET_tb,
			R => R_tb,
			CE => CE_tb,
			D_val => D_val_tb,
			TC => TC_tb,
			D_in => D_in_tb,
			D_out => D_out_tb,
			Wrl => Wrl_tb,
			done => done_tb
);

clk_gen: process
begin
	clk_tb <= '0';
	wait for MCLK_HALF_PERIOD;
	clk_tb <= '1';
	wait for MCLK_HALF_PERIOD;
end process;

stimulus: process
begin 

-- reset a '1'
D_in_tb <= "110010101";
RESET_tb <= '1';
D_val_tb <= '0';
TC_tb <= '0';
wait for MCLK_PERIOD;

-- reset a '0'

RESET_tb <= '0';

wait for MCLK_PERIOD;

-- Dval a 1
D_val_tb <= '1';

wait for MCLK_PERIOD*12;

-- TC a 1 
TC_tb <= '1';

wait for MCLK_PERIOD*2;

--Dval a 0
D_val_tb <= '0';
TC_tb <= '0';
D_in_tb <= "111100101";
wait for MCLK_PERIOD;

-- reset a '0'

RESET_tb <= '0';

wait for MCLK_PERIOD;

-- Dval a 1
D_val_tb <= '1';

wait for MCLK_PERIOD*12;

-- TC a 1 
TC_tb <= '1';

wait for MCLK_PERIOD;


wait;

end process;

end architecture;
