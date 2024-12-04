library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
  
entity Compare is
port (
terminalValue: in std_logic_vector(1 downto 0);
Q: in std_logic_vector(1 downto 0);
TC: out std_logic
);
end Compare;
  
architecture ARCH_Compare of Compare is

Begin 

TC <= (not (terminalValue(0) xor Q(0))) and (not (terminalValue(1) xor Q(1)));

end ARCH_Compare;