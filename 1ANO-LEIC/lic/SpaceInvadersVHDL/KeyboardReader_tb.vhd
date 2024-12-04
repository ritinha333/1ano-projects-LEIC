LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity KeyboardReader_tb is
end KeyboardReader_tb;

architecture behavioral of KeyboardReader_tb is


component KeyboardReader is
port(
	R: in std_logic; --Reset
	CLK : in std_logic;
	ACK: in std_logic;
	Lines: in std_logic_vector(3 downto 0);
	Collumns: out std_logic_vector(2 downto 0);
	D_val: out std_logic;
	D: out std_logic_vector(3 downto 0)
);
end component;


--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal R_tb: std_logic;
signal clk_tb: std_logic;
signal ACK_tb: std_logic;
signal Lines_tb: std_logic_vector(3 downto 0);
signal Collumns_tb: std_logic_vector(2 downto 0);
signal D_val_tb: std_logic;
signal D_tb: std_logic_vector(3 downto 0);

begin

---Unit Under Test
UUT: KeyboardReader
port map(
	R => R_tb,
	CLK => clk_tb,
	ACK => ACK_tb,
	Lines => Lines_tb,
	Collumns => Collumns_tb,
	D_val => D_val_tb,
	D => D_tb
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

-- Sinais iniciais
R_tb <= '1';
Lines_tb <= "1111";
ACK_tb <= '0';

wait for MCLK_PERIOD*2;

R_tb <= '0';

wait for MCLK_PERIOD*4;

Lines_tb <= "1101"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD;

ACK_tb <= '1';

wait for MCLK_PERIOD;

ACK_tb <= '0';

wait for MCLK_PERIOD;

Lines_tb <= "1110"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "0111"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "0111"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;
 
Lines_tb <= "1011"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "1101"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "1110"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "1110"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

ACK_tb <= '1';

wait for MCLK_PERIOD*2;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

Lines_tb <= "0111"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "1011"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "0111"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

Lines_tb <= "1110"; -- tecla

wait for MCLK_PERIOD*2;

Lines_tb <= "1111";

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait for MCLK_PERIOD*4;

ACK_tb <= '1'; -- get key

wait for MCLK_PERIOD*4;

ACK_tb <= '0';

wait;

end process;

end architecture;