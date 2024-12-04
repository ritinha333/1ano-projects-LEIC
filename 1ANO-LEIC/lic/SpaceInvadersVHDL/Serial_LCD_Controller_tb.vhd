LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_LCD_Controller_tb is
end Serial_LCD_Controller_tb;

architecture behavioral of Serial_LCD_Controller_tb is

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

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal CLK_tb: std_logic;
signal SS_tb: std_logic;
signal SCLK_tb: std_logic;
signal SDX_tb: std_logic;
signal R_tb: std_logic;
signal D_out_tb: std_logic_vector (8 downto 0);
signal Wrl_tb: std_logic;

begin

---Unit Under Test
UUT: Serial_LCD_Controller
port map(
	CLK => CLK_tb,
	SS => SS_tb,
	SCLK => SCLK_tb,
	SDX => SDX_tb,
	D_out => D_out_tb,
	Wrl => Wrl_tb,
	R => R_tb
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

--fazer reset ao módulo de topo
R_tb <= '1';
SS_tb <= '1';

wait for MCLK_PERIOD*2;


--levar o reset a zero
R_tb <= '0';
SCLK_tb <= '0';
wait for MCLK_PERIOD*2;

-- LCDsel ativo
SS_tb <= '0';

wait for MCLK_PERIOD;

-- Envia um primeiro bit
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um segundo bit
SCLK_tb <= '0';
SDX_tb <= '0';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um terceiro bit
SCLK_tb <= '0';
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um quarto bit
SCLK_tb <= '0';
SDX_tb <= '0';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um quinto bit
SCLK_tb <= '0';
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um sexto bit
SCLK_tb <= '0';
SDX_tb <= '0';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um sétimo bit
SCLK_tb <= '0';
SDX_tb <= '0';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um oitavo bit
SCLK_tb <= '0';
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um nono bit
SCLK_tb <= '0';
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Envia um bit de paridade
SCLK_tb <= '0';
SDX_tb <= '1';
wait for MCLK_PERIOD;

SCLK_tb <= '1';
wait for MCLK_PERIOD*2;

-- Com a trama "110010101", o valor de D_out deve ser "0010101"

--Sinal do accept '0'
SS_tb <= '1';

wait for MCLK_PERIOD*2;


wait;

end process;

end architecture;





