LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MemoryAddressControl_tb is
end MemoryAddressControl_tb;

architecture behavioral of MemoryAddressControl_tb is

component MemoryAddressControl is
port(
	R: in std_logic;
	putget: in std_logic;
	incPut: in std_logic;
	incGet: in std_logic;
	CLK: in std_logic;
	full: out std_logic;
	empty: out std_logic;
	A: out std_logic_vector(2 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal R_tb: std_logic;
signal putget_tb: std_logic;
signal clk_tb: std_logic;
signal incPut_tb: std_logic;
signal incGet_tb: std_logic;
signal full_tb: std_logic;
signal empty_tb: std_logic;
signal A_tb: std_logic_vector(2 downto 0);

begin

---Unit Under Test
UUT: MemoryAddressControl
port map(
	R => R_tb,
	putget => putget_tb,
	CLK => clk_tb,
	full => full_tb,
	empty => empty_tb,
	incPut => incPut_tb,
	incGet => incGet_tb,
	A => A_tb
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
putget_tb <= '0';
incPut_tb <= '0';
incGet_tb <= '0';

wait for MCLK_PERIOD*2;

R_tb <= '0';

wait for MCLK_PERIOD*2;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

incPut_tb <= '0';
putget_tb <= '0';
incGet_tb <= '1';

wait for MCLK_PERIOD*2;

incGet_tb <= '0';
putget_tb <= '1';
incPut_tb <= '1';

wait for MCLK_PERIOD;

inCPut_tb <= '0';
putget_tb <= '0';
incGet_tb <= '1';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '1';
incPut_tb <= '1';
incGet_tb <= '0';

wait for MCLK_PERIOD;

putget_tb <= '0';
incGet_tb <= '0';
inCPut_tb <= '0';

wait;

end process;

end architecture;