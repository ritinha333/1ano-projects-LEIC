LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Decoder is
port(
S : in std_logic_vector(1 downto 0);
C : out STD_LOGIC_VECTOR(2 downto 0)
);
end Decoder;

architecture arq_Decoder of Decoder is

begin

-- falta simplificar;
C(0) <= not ((not S(1)) and (not S(0)));
C(1) <= not ((not S(1)) and S(0));
C(2) <= not (S(1) and (not S(0)));

end arq_Decoder;