LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity avaliacao_intercalar1_tb is
end avaliacao_intercalar1_tb;

architecture behavioral of avaliacao_intercalar1_tb is

component avaliacao_intercalar1 IS
PORT( 
R: in std_logic; --Reset
CLK : in std_logic;
Lines: in std_logic_vector(3 downto 0);
Collumns: out std_logic_vector(2 downto 0);
D: out std_logic_vector(8 downto 0);

-- USBPort output (sim)
SDX: in std_logic;
SS: in std_logic;
SCLK: in std_logic;
SACK: in std_logic;
--------

EN: out std_logic
);
END component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal R_tb: std_logic;
signal clk_tb: std_logic;
signal Lines_tb: std_logic_vector (3 downto 0);
signal Collumns_tb: std_logic_vector (2 downto 0);
signal D_tb: std_logic_vector (8 downto 0);
signal SS_tb: std_logic;
signal SDX_tb: std_logic;
signal SCLK_tb: std_logic;
signal SACK_tb: std_logic;

begin

---Unit Under Test
UUT: avaliacao_intercalar1
port map( 
	R => R_tb,
	CLK => clk_tb,
	Lines => Lines_tb,
	Collumns => Collumns_tb,
	D => D_tb,
	SDX => SDX_tb,
	SS => SS_tb,
	SCLK => SCLK_tb,
	SACK => SACK_tb
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

-- Valores iniciais
R_tb <= '1';
Lines_tb <= "1111";
SDX_tb <= '0'; 
SS_tb <= '1';
SCLK_tb <= '0'; 
SACK_tb <= '0';

wait for MCLK_PERIOD*2;

R_tb <= '0';

wait for MCLK_PERIOD*2;

Lines_tb <= "1110";

wait for MCLK_PERIOD*2;

SACK_tb <= '1';

wait for MCLK_PERIOD*2;

SACK_tb <= '0';

-- Start serial emitter
wait for MCLK_PERIOD*2;

SS_tb <= '0';
---------------------
wait for MCLK_PERIOD;
SDX_tb <= '1';
SCLK_tb <= '1';

wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';

wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '1';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '1';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '1';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SDX_tb <= '0';
SCLK_tb <= '1';


wait for MCLK_PERIOD;
SCLK_tb <= '0';
wait for MCLK_PERIOD;
---------------------
SS_tb <= '1';

wait;

end process;

end architecture;