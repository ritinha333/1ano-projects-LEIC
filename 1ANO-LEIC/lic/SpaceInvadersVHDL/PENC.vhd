LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity PriorityEncoder is
port (
I: in std_logic_vector(3 downto 0);
Y: out std_logic_vector(1 downto 0);
gs: out std_logic
);
end PriorityEncoder;

architecture Structural of PriorityEncoder is
begin
	Y(0) <= I(1) or I(3);
   Y(1) <= I(2) or I(3);
	gs <= I(0) or I(1) or I(2) or I(3);
end Structural;
