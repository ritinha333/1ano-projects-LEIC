LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MUX41_tb is
end MUX41_tb;

architecture behavioral of MUX41_tb is

component MUX41 is
port(
A : in STD_LOGIC_VECTOR(3 downto 0);
B : in STD_LOGIC_VECTOR(3 downto 0);
S : in std_logic;
Y : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal A_tb: std_logic_vector(3 downto 0);
signal B_tb: std_logic_vector(3 downto 0);
signal S_tb: std_logic;
signal Y_tb: std_logic_vector(3 downto 0);


begin

---Unit Under Test
UUT: MUX41
port map(A => A_tb,
			B => B_tb,
			S => S_tb,
			Y => Y_tb
			);

stimulus: process
begin 

A_tb <= "1010";
B_tb <= "1100";

-- Caso S_tb = 0 seleciona B
S_tb <= '0';
wait for 10 ns;

-- Caso S_tb = 1 seleciona A
S_tb <= '1';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb <= '0';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb <= '0';
wait for 10 ns;

-- Caso S_tb = 1 seleciona A
S_tb <= '1';
wait for 10 ns;

-- Caso S_tb = 1 seleciona A
S_tb <= '1';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb <= '0';
wait for 10 ns;

-- Caso S_tb = 1 seleciona A
S_tb <= '1';
wait for 10 ns;

-- Caso S_tb = 1 seleciona A
S_tb <= '1';
wait for 10 ns;

-- Caso S_tb = 0 seleciona B
S_tb <= '0';
wait for 10 ns;
wait;

end process;

end architecture;