LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Penc_tb is
end Penc_tb;

architecture teste of Penc_tb is
component Penc
  port(I0, I1, I2, I3, I4, I5, I6, I7 : in STD_LOGIC;
	   O0, O1, O2 : out STD_LOGIC;
	   V : out STD_LOGIC
  );
end component;

signal I0, I1, I2, I3, I4, I5, I6, I7 : STD_LOGIC;
signal O0, O1, O2 : STD_LOGIC;
signal V : STD_LOGIC;

begin

U0 : Penc port map (I0 => I0, I1 => I1, I2 => I2, I3 => I3, I4 => I4, I5 => I5, I6 => I6, I7 => I7, 
		     O0 => O0, O1 => O1, O2 => O2, V => V);

process
begin
 I0 <= '1';
 I1 <= '0';
 I2 <= '1';
 I3 <= '0';
 I4 <= '1';
 I5 <= '0';
 I6 <= '0';
 I7 <= '0';
 wait for 10 ns;

 I0 <= '1';
 I1 <= '0';
 I2 <= '1';
 I3 <= '0';
 I4 <= '0';
 I5 <= '0';
 I6 <= '0';
 I7 <= '0';
 wait for 10 ns;

 I0 <= '1';
 I1 <= '0';
 I2 <= '1';
 I3 <= '0';
 I4 <= '1';
 I5 <= '0';
 I6 <= '1';
 I7 <= '1';
 wait for 10 ns;

 I0 <= '0';
 I1 <= '0';
 I2 <= '0';
 I3 <= '0';
 I4 <= '0';
 I5 <= '0';
 I6 <= '0';
 I7 <= '0';
 wait for 10 ns;

 I0 <= '1';
 I1 <= '1';
 I2 <= '1';
 I3 <= '1';
 I4 <= '1';
 I5 <= '1';
 I6 <= '1';
 I7 <= '1';
 wait for 10 ns;

wait;

end process;

end teste;
