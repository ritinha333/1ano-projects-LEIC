library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder is
	port (S: in std_logic_vector(1 downto 0);
			O: out std_logic_vector (3 downto 0));
			
end Decoder;

architecture arqDecoder of Decoder is
begin

O(0)<= not S(1) and not S(0);
O(1)<= not S(1) and S(0);
O(2)<= S(1) and not S(0);
O(3)<= S(1) and S(0);

end arqDecoder;

