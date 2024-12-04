LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyDecode_tb is
end KeyDecode_tb;

architecture behavioral of KeyDecode_tb is

component Key_Decode is
port(
	R: in std_logic;
	CLK : in std_logic;
	K_ack: in std_logic;
	Lines: in std_logic_vector(3 downto 0);
	Collumns: out std_logic_vector(2 downto 0);
	K_val: out std_logic;
	K: out std_logic_vector(3 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal Kack_tb: std_logic;
signal clk_tb: std_logic;
signal pins_E_tb: std_logic_vector (3 downto 0);
signal pins_S_tb: std_logic_vector (2 downto 0);
signal Kval_tb: std_logic;
signal K_tb: std_logic_vector (3 downto 0);
signal R_tb: std_logic;

begin

---Unit Under Test
UUT: Key_Decode
port map(K_val => Kval_tb,
			CLK => clk_tb,
			Lines => pins_E_tb,
			Collumns => pins_S_tb,
			K_ack => Kack_tb,
			R => R_tb,
			K => K_tb);

clk_gen: process
begin
	clk_tb <= '0';
	wait for MCLK_HALF_PERIOD;
	clk_tb <= '1';
	wait for MCLK_HALF_PERIOD;
end process;

stimulus: process
begin 

-- Reset a 1
R_tb <= '1';
wait for MCLK_PERIOD*2;

-- Reset e Kack a 0
R_tb <= '0';
Kack_tb <= '0';

-- Pinos de linha a 1 (não pressionados)
pins_E_tb <= "1111"; 
wait for MCLK_PERIOD*2;

-- Pressionar terceira linha e observar Kpress
pins_E_tb <= "1101"; 
wait for MCLK_PERIOD;

-- Kack a 1 para prosseguir pro próximo estado
Kack_tb <= '1';
wait for MCLK_PERIOD*2;

-- Kack a 0 para prosseguir pro próximo estado
Kack_tb <= '0';
wait for MCLK_PERIOD*2;

-- Pinos de linha a 1 para Kpress ir a 0 e prosseguir pro próximo estado
pins_E_tb <= "1111";
wait for MCLK_PERIOD*2;

-- Tres linhas pressionadas para verificar comportamento esperado (prioridade para bit de maior peso)
pins_E_tb <= "0001";
wait for MCLK_PERIOD*2;

-- Kack a 1 para prosseguir pro próximo estado
Kack_tb <= '1';
wait for MCLK_PERIOD*2;

-- Pinos de linha a 1 para Kpress ir a 0, mas deve-se manter no mesmo estado
pins_E_tb <= "1111";
wait for MCLK_PERIOD*2;

-- Kack a 0 deve ir para o próximo estado e logo após voltar para o primeiro estado
Kack_tb <= '0';
wait;

end process;

end architecture;