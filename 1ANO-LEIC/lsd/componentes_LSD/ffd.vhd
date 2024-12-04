LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FFD IS
PORT(
	CLK, RESET, SET, D, EN : in std_logic;
	Q : out std_logic);
END FFD;

ARCHITECTURE logicFunction OF FFD IS

BEGIN
Q <= '0' when RESET = '1' else '1' when SET = '1' else D WHEN rising_edge(clk) and EN = '1';

END logicFunction;