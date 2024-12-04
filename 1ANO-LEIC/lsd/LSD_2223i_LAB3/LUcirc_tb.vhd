LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity LUcirc_tb is
end LUcirc_tb;

architecture teste of LUcirc_tb is
component LUcirc
  port(X, Y : in STD_LOGIC_VECTOR(3 downto 0);
  	Op : in STD_LOGIC;
	R : out STD_LOGIC_VECTOR(3 downto 0)
  );
end component;

signal X, Y : std_logic_vector(3 downto 0);
signal Op : std_logic;
signal R : std_logic_vector(3 downto 0);

begin

U0 : LUcirc port map (X => X, Y => Y, 
		     S => S, R => R);

process
begin
 X <= "0101"; 
 Y <= "1100"; 
 Op <= '0';
 wait for 10 ns;

 X <= "0101";
 Y <= "1100";
 Op <= '1';

wait;

end process;

end teste;
