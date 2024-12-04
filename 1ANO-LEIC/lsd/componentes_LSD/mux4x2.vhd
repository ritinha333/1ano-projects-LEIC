LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity mux4x2 is 
    port(
        A: in std_logic_vector(3 downto 0);
		  S: in std_logic_vector(1 downto 0);
        O: out std_logic);
end mux4x2;

architecture arch_MUX of mux4x2 is

    begin
        O <= (not S(0) and not S(1) and A(0)) 
		       or (S(0) and not S(1) and A(1))
				 or (not S(0) and S(1) and A(2))
				 or (S(0) and S(1) and A(3));


end arch_MUX;