LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity LCD_Dispatcher is 
port(	
		CLK: in std_logic;
		RESET: in std_logic;
		R: out std_logic;
		CE: out std_logic;
		D_val: in std_logic;
		TC: in std_logic;
		D_in: in std_logic_vector (8 downto 0);
		D_out: out std_logic_vector (8 downto 0);
		Wrl: out std_logic;
		done: out std_logic
);

end LCD_Dispatcher;
 
architecture behavioral of LCD_Dispatcher is

type LCD_DISPATCHER_STATE is (WAIT_D_VAL, WAIT_TC, WAIT_NOT_D_VAL);

signal CurrentState, NextState: LCD_DISPATCHER_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_D_VAL when RESET = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, D_val, TC)
	begin
		case CurrentState is
			when WAIT_D_VAL 		=> 		if (D_val = '0') 	then
														NextState <= WAIT_D_VAL;
													else
														NextState <= WAIT_TC;
													end if;
									
			when WAIT_TC 			=> 		if (TC = '0') 		then
														NextState <= WAIT_TC;
													else
														NextState <= WAIT_NOT_D_VAL;
													end if;
			
			when WAIT_NOT_D_VAL 	=> 			if (D_val = '1') 	then
														NextState <= WAIT_NOT_D_VAL;
													else
														NextState <= WAIT_D_VAL;
													end if;
											
		end case;
	end process;

-- Generate Outputs
Wrl <= '1' when (CurrentState = WAIT_TC)
				else '0';

done <= '1' when (CurrentState = WAIT_NOT_D_VAL)
					else '0';
					
R <= '1' when (CurrentState = WAIT_D_VAL)
					else '0';

CE <= '1' when (CurrentState = WAIT_TC)
				else '0';

D_out <= D_in;

end behavioral;