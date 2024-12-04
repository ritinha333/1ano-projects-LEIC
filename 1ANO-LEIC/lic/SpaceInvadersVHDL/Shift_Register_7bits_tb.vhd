LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Shift_Register_7bits_tb is
end Shift_Register_7bits_tb;

architecture behavioral of Shift_Register_7bits_tb is

component Shift_Register_7bits is
port(
Sin 	: in std_logic;	--Serial in
S_PL 	: in std_logic; -- Shift/Write
enableShift	: in std_logic;
clr 	: in std_logic;
clk 	: in std_logic;
D		: in std_logic_vector(6 downto 0);
Sout 	: out std_logic;
Q 		: out std_logic_vector(6 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal Sin_tb: std_logic;
signal S_PL_tb: std_logic;
signal enableShift_tb: std_logic;
signal clr_tb: std_logic;
signal clk_tb: std_logic;
signal D_tb: std_logic_vector(6 downto 0);
signal Sout_tb: std_logic;
signal Q_tb: std_logic_vector(6 downto 0);

begin

---Unit Under Test
UUT: Shift_Register_7bits
port map(Sin => Sin_tb,
			S_PL => S_PL_tb,
			enableShift => enableShift_tb,
			clr => clr_tb,
			clk => clk_tb,
			D => D_tb,
			Sout => Sout_tb,
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

-- habilitar o shift e o clr a '0'
enableShift_tb <= '1';
clr_tb <= '0';
wait for MCLK_PERIOD*2;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift

Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Clear dos registos do ShiftRegister
enableShift_tb <= '0';
clr_tb <= '1';
wait for MCLK_PERIOD*2;


-- Envio de uma próxima trama fazendo enable ao shift e clr = '0'
enableShift_tb <= '1';
clr_tb <= '0';
wait for MCLK_PERIOD*2;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift
Sin_tb <= '0';
wait for MCLK_PERIOD;

-- Shift

Sin_tb <= '1';
wait for MCLK_PERIOD;

-- Clear dos registos do ShiftRegister
enableShift_tb <= '0';
clr_tb <= '1';
wait for MCLK_PERIOD*2;


wait;

end process;

end architecture;
