LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity RingBuffer_tb is
end RingBuffer_tb;

architecture behavioral of RingBuffer_tb is

component RingBuffer is
port(
	R: in std_logic;
	CLK : in std_logic;
	D: in std_logic_vector(3 downto 0);
	DAV: in std_logic;
	CTS: in std_logic;
	DAC: out std_logic;
	Wreg: out std_logic;
	Q: out std_logic_vector(3 downto 0)
);
end component;


--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal R_tb: std_logic;
signal clk_tb: std_logic;
signal D_tb: std_logic_vector(3 downto 0);
signal DAV_tb: std_logic;
signal CTS_tb: std_logic;
signal DAC_tb: std_logic;
signal Wreg_tb: std_logic;
signal Q_tb: std_logic_vector(3 downto 0);

begin

---Unit Under Test
UUT: RingBuffer
port map(
	R => R_tb,
	CLK => clk_tb,
	D => D_tb,
	DAV => DAV_tb,
	CTS => CTS_tb,
	DAC => DAC_tb,
	Wreg => Wreg_tb,
	Q => Q_tb
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
D_tb <= "0000";
DAV_tb <= '0';
CTS_tb <= '0';

wait for MCLK_PERIOD*2;

R_tb <= '0';

wait for MCLK_PERIOD*2;

D_tb <= "1000";
DAV_tb <= '1';

wait for MCLK_PERIOD*2;

DAV_tb <= '0';
D_tb <= "0110";

wait for MCLK_PERIOD*2;

DAV_tb <= '1';

wait for MCLK_PERIOD;

D_tb <= "0001";

wait for MCLK_PERIOD*2;

DAV_tb <= '0';
D_tb <= "0001";

wait for MCLK_PERIOD*2;

DAV_tb <= '1'; 
wait for MCLK_PERIOD;

D_tb <= "1111";
DAV_tb <= '0';

wait for MCLK_PERIOD;

D_tb <= "0000";
DAV_tb <= '1';

wait for MCLK_PERIOD*2;

CTS_tb <= '1';

wait for MCLK_PERIOD*2;

DAV_tb <= '0';

wait for MCLK_PERIOD*2;

D_tb <= "0010";
DAV_tb <= '1';

wait for MCLK_PERIOD*2;

DAV_tb <= '0'; 

wait for MCLK_PERIOD*2;

D_tb <= "0001";
DAV_tb <= '1';

wait for MCLK_PERIOD*2;

D_tb <= "0110";

wait;

end process;

end architecture;