LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity mux2x1 is 
    port(
        A, B: in std_logic_vector(3 downto 0);
        S: in std_logic;
        O: out std_logic_vector(3 downto 0));
end mux2x1;

architecture arch_MUX of mux2x1 is

    begin
        O(0) <= (S and B(0)) or (not S and A(0));
        O(1) <= (S and B(1)) or (not S and A(1));
        O(2) <= (S and B(2)) or (not S and A(2));
        O(3) <= (S and B(3)) or (not S and A(3));

end arch_MUX;