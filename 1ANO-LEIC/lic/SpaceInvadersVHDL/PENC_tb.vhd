LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity PriorityEncoder_tb is
end PriorityEncoder_tb;

architecture behavioral of PriorityEncoder_tb is

component PriorityEncoder is
port (
I: in std_logic_vector(3 downto 0);
Y: out std_logic_vector(1 downto 0);
gs: out std_logic
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal I_tb: std_logic_vector(3 downto 0);
signal Y_tb: std_logic_vector(1 downto 0);
signal gs_tb: std_logic;


begin

---Unit Under Test
UUT: PriorityEncoder
port map(I => I_tb,
			Y => Y_tb,
			gs => gs_tb
			);

stimulus: process
begin 

-- Começar reset a 1
I_tb <= "0000";
wait for 10 ns;
-- kScan a 01, K deve manter igual e as saídas do decoder também

I_tb <= "0001";
wait for 10 ns;

-- kscan a 10, o contador deve estar enabled e saídas do decoder devem mudar
I_tb <= "0010";
wait for 10 ns;

-- kscan ainda 10, e forçar linha a 1, saida deve ser a tecla "pressionada" - esperar alguns ciclos de clock
I_tb <= "0011";
wait for 10 ns;

I_tb <= "0100";
wait for 10 ns;

I_tb <= "0111";
wait for 10 ns;

I_tb <= "1000";
wait for 10 ns;

I_tb <= "1111";
wait for 10 ns;
wait;

end process;

end architecture;