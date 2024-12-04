library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity Compare4 is
port (
terminalValue: in std_logic_vector(3 downto 0);
Q: in std_logic_vector(3 downto 0);
TC: out std_logic
);
end Compare4;
  
architecture ARCH_Compare4 of Compare4 is

Begin 

TC <= (not (terminalValue(0) xor Q(0))) and (not (terminalValue(1) xor Q(1))) 
		and (not (terminalValue(2) xor Q(2))) and (not (terminalValue(3) xor Q(3)));

end ARCH_Compare4;