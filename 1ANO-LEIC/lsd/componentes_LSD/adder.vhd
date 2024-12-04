LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity adder is
    port(
        A, B: in std_logic_vector(3 downto 0);
        Ci: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Co: out std_logic);
end adder;

architecture arch_adder of adder is 

    component fullAdder
        port(
            A, B, Cn: in std_logic;
            S, Cn_1: out std_logic);
    end component;

    signal c1, c2, c3: STD_LOGIC;

    begin 
        
        U0: fullAdder port map (A => A(0), B => B(0), Cn => Ci, Cn_1 => c1, S => S(0));
        U1: fullAdder port map (A => A(1), B => B(1), Cn => c1, Cn_1 => c2, S => S(1));
        U2: fullAdder port map (A => A(2), B => B(2), Cn => c2, Cn_1 => c3, S => S(2));
        U3: fullAdder port map (A => A(3), B => B(3), Cn => c3, Cn_1 => cO, S => S(3));
	
end arch_adder;