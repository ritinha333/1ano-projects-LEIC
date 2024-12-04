LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX42_tb is
end MUX42_tb;

architecture behavioral of MUX42_tb is

component MUX42 is
port(
K : in STD_LOGIC_VECTOR(3 downto 0);
S : in std_logic_vector(1 downto 0);
Y : out STD_LOGIC
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal K_tb: std_logic_vector(3 downto 0);
signal S_tb: std_logic_vector(1 downto 0);
signal Y_tb: std_logic;


begin

---Unit Under Test
UUT: MUX42
port map(K => K_tb,
			S => S_tb,
			Y => Y_tb
			);

stimulus: process
begin 

K_tb <= "1001";

-- Caso S_tb = 0 seleciona B
S_tb(0) <= '0';
S_tb(1) <= '0';
K_tb(0) <= '1';
wait for 10 ns;

S_tb(0) <= '0';
S_tb(1) <= '0';
K_tb(0) <= '1';
wait for 10 ns;


-- Caso S_tb = 1 seleciona A
S_tb(0) <= '1';
S_tb(1) <= '0';
K_tb(1) <= '1';
wait for 10 ns;

S_tb(0) <= '1';
S_tb(1) <= '0';
K_tb(1) <= '0';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb(0) <= '0';
S_tb(1) <= '1';
K_tb(2) <= '0';
wait for 10 ns;

S_tb(0) <= '0';
S_tb(1) <= '1';
K_tb(2) <= '1';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb(0) <= '1';
S_tb(1) <= '1';
K_tb(3) <= '1';
wait for 10 ns;

S_tb(0) <= '1';
S_tb(1) <= '1';
K_tb(3) <= '0';
wait for 10 ns;

wait;

end process;

end architecture;