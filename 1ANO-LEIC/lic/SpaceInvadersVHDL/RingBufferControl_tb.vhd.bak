LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KEYSCAN_tb is
end KEYSCAN_tb;

architecture behavioral of KEYSCAN_tb is

component Key_Scan is
port(
		CLK: in std_logic; 
		K_scan: in std_logic_vector (1 downto 0);
		Lines: in std_logic_vector (3 downto 0);
		R: in std_logic;
		Collumns: out std_logic_vector (2 downto 0);
		K_press: out std_logic;
		K: out std_logic_vector (3 downto 0)
		);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal Kscan_tb: std_logic_vector(1 downto 0);
signal clk_tb: std_logic;
signal pins_E_tb: std_logic_vector (3 downto 0);
signal pins_S_tb: std_logic_vector (2 downto 0);
signal Kpress_tb: std_logic;
signal K_tb: std_logic_vector (3 downto 0);
signal R_tb: std_logic;

begin

---Unit Under Test
UUT: Key_Scan
port map(K_scan => Kscan_tb,
			CLK => clk_tb,
			Lines => pins_E_tb,
			Collumns => pins_S_tb,
			K_press => Kpress_tb,
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

-- Começar reset a 1
R_tb <= '1';
pins_E_tb <= "1111";

wait for MCLK_PERIOD*2;

R_tb <= '0';

-- kScan a 01, K deve manter igual e as saídas do decoder também

Kscan_tb <= "01";
wait for MCLK_PERIOD*15;

-- kscan a 10, o contador deve estar enabled e saídas do decoder devem mudar
Kscan_tb <= "10";
wait for MCLK_PERIOD*15;

-- kscan ainda 10, e forçar linha a 1, saida deve ser a tecla "pressionada" - esperar alguns ciclos de clock
pins_E_tb <= "1101";

wait for MCLK_PERIOD*2;

Kscan_tb <= "01";

wait for MCLK_PERIOD*2;
pins_E_tb <= "1111";

wait;

end process;

end architecture;