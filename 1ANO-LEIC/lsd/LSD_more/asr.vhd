library ieee;
use ieee.std_logic_1164.all;
entity asr is
 port(A: in std_logic_vector (3 downto 0);
      B: in std_logic_vector (3 downto 0);
		Cy: out std_logic;
		R: out std_logic_vector (3 downto 0));
end asr;

architecture arq_asr of asr is

begin

	R(3) <= (B(1) and B(0) and A(3)) or (B(1) and not B(0) and A(3)) or (not B(1) and B(0) and A(3)) or (not B(1) and not B(0) and A(3));
	R(2) <= (not B(1) and not B(0) and A(2)) or (B(1) and not B(0) and A(3)) or (not B(1) and B(0) and A(3)) or (B(1) and B(0) and A(3));
	R(1) <= (not B(1) and not B(0) and A(1)) or (not B(1) and B(0) and A(2)) or (not B(0) and B(1) and A(3)) or (B(0) and B(1) and A(3));
	R(0) <= (not B(1) and not B(0) and A(0)) or (not B(1) and B(0) and A(1)) or (B(1) and not B(0) and A(2)) or (B(1) and B(0) and A(3));
	Cy <= (not B(1) and B(0) and A(1)) or (B(1) and not B(0) and A(2)) or (B(1) and B(0) and A(3));
	
	end arq_asr;
	