LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tests IS

PORT(A, B, C : IN STD_LOGIC;
		F : OUT STD_LOGIC);
		
END tests;

ARCHITECTURE logicFunction OF tests IS

BEGIN
F <= (A AND NOT B) OR (NOT A AND C);
END LogicFunction;