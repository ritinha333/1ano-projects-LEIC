

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ASM_Microprogrammed_i2223 is
port (MCLK, Y, Z, RST: in std_logic;
		S1, S0: out std_logic
		);
end ASM_Microprogrammed_i2223;

architecture ASM_Microprogrammed_i2223_arch of ASM_Microprogrammed_i2223 is

	type ROM_type is array (0 to 15) of std_logic_vector(3 downto 0);
	
	constant ROM: ROM_type := (0 	=> "0100",
										1 	=> "0100",
										2 	=> "1110",
										3 	=> "0000",
										4 	=> "1111",
										5 	=> "1111",
										6 	=> "0111",
										7 	=> "0111",
										8 	=> "0110",
										9 	=> "0000",
										10	=> "0000",
										11 => "0110",
										12 => "1001",
										13 => "1000",
										14 => "1001",
										15 => "1000");
										
	component FFD
	port(	CLK : in std_logic;
			RESET : in STD_LOGIC;
			SET : in std_logic;
			D : IN STD_LOGIC;
			EN : IN STD_LOGIC;
			Q : out std_logic
			);
	end component;
	
	signal ADDR: std_logic_vector (3 downto 0);
	signal DATA: std_logic_vector (3 downto 0);
	signal EP: std_logic_vector(1 downto 0);
	
begin

	UX0: FFD port map (CLK => MCLK, RESET => RST, SET => '0', D => DATA(2), EN => '1', Q => EP(0));
	UX1: FFD port map (CLK => MCLK, RESET => RST, SET => '0', D => DATA(3), EN => '1', Q => EP(1));
	ADDR <= EP(1) & EP(0) & Y & Z;
	DATA <= ROM( to_integer(unsigned(ADDR)));
	S0 <= DATA(1);
	S1 <= DATA(0);
	
end ASM_Microprogrammed_i2223_arch;
