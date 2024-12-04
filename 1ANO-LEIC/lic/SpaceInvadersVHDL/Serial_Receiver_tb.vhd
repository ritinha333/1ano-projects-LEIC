LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_Receiver_tb is
end Serial_Receiver_tb;

architecture behavioral of Serial_Receiver_tb is

component Serial_Receiver is
port(	SDX: in std_logic;
		SCLK: in std_logic;
		accept: in std_logic;
		CLK: in std_logic;
		SS: in std_logic;
		R: in std_logic;
		D: out std_logic_vector (8 downto 0);
		DX_val: out std_logic
);

end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal SDX_tb: std_logic;
signal SCLK_tb: std_logic;
signal accept_tb: std_logic;
signal CLK_tb: std_logic;
signal SS_tb: std_logic;
signal R_tb: std_logic;
signal D_tb: std_logic_vector (8 downto 0);
signal DX_val_tb: std_logic;

begin

---Unit Under Test
UUT: Serial_Receiver
port map(SDX => SDX_tb,
			SCLK => SCLK_tb,
			accept => accept_tb,
			CLK => clk_tb,
			SS => SS_tb,
			R => R_tb,
			D => D_tb,
			DX_val =>  DX_val_tb
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

--fazer reset ao módulo
R_tb <= '1';
SS_tb <= '1';

wait for MCLK_PERIOD*2;


--reset a zero
R_tb <= '0';
SCLK_tb <= '0';

wait for MCLK_PERIOD*2;

-- LCDsel ativo ao qual o primeiro bit a enviar é 1 e accept a '1'
SS_tb <= '0';
accept_tb <= '0';

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

--Sinal do accept '0'
accept_tb <= '1';
SS_tb <= '1';

wait for MCLK_PERIOD*2;

wait;

end process;

end architecture;





