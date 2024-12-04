LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Score_Dispatcher is 
port(	
		CLK: in std_logic;
		RESET: in std_logic;
		R: out std_logic;
		D_val: in std_logic;
		D_in: in std_logic_vector (6 downto 0);
		D_out: out std_logic_vector (6 downto 0);
		Wrl: out std_logic;
		done: out std_logic
);

end Score_Dispatcher;
 
architecture behavioral of Score_Dispatcher is

type SPCORE_DISPATCHER_STATE is (WAIT_NOT_D_VAL, WAIT_D_VAL);

signal CurrentState, NextState: SPCORE_DISPATCHER_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_NOT_D_VAL when RESET = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, D_val)
	begin
		case CurrentState is
			when WAIT_NOT_D_VAL 		=> 	if (D_val = '0') 	then
														NextState <= WAIT_NOT_D_VAL;
													else
														NextState <= WAIT_D_VAL;
													end if;


			when WAIT_D_VAL 	=> 			if (D_val = '1') 	then
														NextState <= WAIT_D_VAL;
													else
														NextState <= WAIT_NOT_D_VAL;
													end if;

		end case;
	end process;

-- Generate Outputs
Wrl <= '1' when (CurrentState = WAIT_D_VAL)
				else '0';

done <= '1' when (CurrentState = WAIT_D_VAL)
					else '0';
					
R <= '1' when (CurrentState = WAIT_NOT_D_VAL)
					else '0';

D_out <= D_in;


end behavioral;