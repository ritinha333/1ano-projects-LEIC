LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Decoder_tb is
end Decoder_tb;

architecture behavioral of Decoder_tb is

component Decoder is
port(
S : in std_logic_vector(1 downto 0);
C : out STD_LOGIC_VECTOR(2 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal S_tb: std_logic_vector(1 downto 0);
signal C_tb: std_logic_vector(2 downto 0);


begin

---Unit Under Test
UUT: Decoder
port map(S => S_tb,
			C => C_tb
			);

stimulus: process
begin 


-- Caso S_tb(1) = 0 e S_tb(0) = 0 seleciona a primeira saída C(0)
S_tb(0) <= '0';
S_tb(1) <= '0';
wait for 10 ns;

-- Caso S_tb(1) = 0 e S_tb(0) = 1 seleciona a primeira saída C(1)
S_tb(0) <= '1';
S_tb(1) <= '0';
wait for 10 ns;


-- Caso S_tb(1) = 1 e S_tb(0) = 0 seleciona a primeira saída C(2)
S_tb(0) <= '0';
S_tb(1) <= '1';
wait for 10 ns;


-- Caso S_tb(1) = 0 e S_tb(0) = 1 seleciona a primeira saída C(1)
S_tb(0) <= '1';
S_tb(1) <= '0';
wait for 10 ns;

-- Caso S_tb(1) = 0 e S_tb(0) = 0 seleciona a primeira saída C(0)
S_tb(0) <= '0';
S_tb(1) <= '0';
wait for 10 ns;


-- Caso S_tb(1) = 1 e S_tb(0) = 0 seleciona a primeira saída C(2)
S_tb(0) <= '0';
S_tb(1) <= '1';
wait for 10 ns;



wait;

end process;

end architecture;