LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity RingBufferControl_tb is
end RingBufferControl_tb;

architecture behavioral of RingBufferControl_tb is

component RingBufferControl is
port(
	R: in std_logic;
	DAV: in std_logic;
	CLK : in std_logic;
	CTS: in std_logic;
	full: in std_logic;
	empty: in std_logic;
	Wr: out std_logic;
	Wreg: out std_logic;
	DAC: out std_logic;
	incPut: out std_logic;
	incGet: out std_logic;
	selPG: out std_logic
		);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal R_tb: std_logic;
signal DAV_tb: std_logic;
signal clk_tb: std_logic;
signal CTS_tb: std_logic;
signal full_tb: std_logic;
signal empty_tb: std_logic;
signal Wr_tb: std_logic;
signal Wreg_tb: std_logic;
signal DAC_tb: std_logic;
signal incPut_tb: std_logic;
signal incGet_tb: std_logic;
signal selPG_tb: std_logic;

begin

---Unit Under Test
UUT: RingBufferControl
port map(
	R => R_tb,
	DAV => DAV_tb,
	CLK => clk_tb,
	CTS => CTS_tb,
	full => full_tb,
	empty => empty_tb,
	Wr => Wr_tb,
	Wreg => Wreg_tb,
	DAC => DAC_tb,
	incPut => incPut_tb,
	incGet => incGet_tb,
	selPG => selPG_tb
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
DAV_tb <= '0';
CTS_tb <= '0';
full_tb <= '0';
empty_tb <= '1';

wait for MCLK_PERIOD*2;

R_tb <= '0';

wait for MCLK_PERIOD*2;

CTS_tb <= '1';

wait for MCLK_PERIOD*2;

DAV_tb <= '1';

wait for MCLK_PERIOD;

empty_tb <= '0';
DAV_tb <= '0';

wait for MCLK_PERIOD*2;

DAV_tb <= '1';

wait for MCLK_PERIOD;

DAV_tb <= '0';

wait for MCLK_PERIOD;

CTS_tb <= '1';

wait for MCLK_PERIOD;

CTS_tb <= '0';

wait for MCLK_PERIOD*2;

full_tb <= '1';

wait for MCLK_PERIOD*2;

DAV_tb <= '1';

wait;

end process;

end architecture;