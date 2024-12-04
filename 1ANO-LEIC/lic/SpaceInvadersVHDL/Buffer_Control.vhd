LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Buffer_Control is
port(
RESET: in std_logic;
CLK : in std_logic;
Load: in std_logic;
ACK: in std_logic;
W_reg: out std_logic;
OB_free: out std_logic;
D_val: out std_logic
);
end Buffer_Control;

architecture behavioral of Buffer_Control is

type BUFFER_STATE is (WAIT_LOAD, WAIT_NOT_LOAD, WAIT_ACK, WAIT_NOT_ACK);

signal CurrentState, NextState: BUFFER_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_LOAD when RESET = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, Load, ACK)
	begin
		case CurrentState is
			when WAIT_LOAD 		=> 	if (Load = '1') 	then
														NextState <= WAIT_NOT_LOAD;
													else
														NextState <= WAIT_LOAD;
													end if;
									
			when WAIT_NOT_LOAD 	=> 	if (Load = '1') 		then
														NextState <= WAIT_NOT_LOAD;
													else
														NextState <= WAIT_ACK;
													end if;
			
			when WAIT_ACK 	=> 			if (ACK = '1') 	then
														NextState <= WAIT_NOT_ACK;
													else
														NextState <= WAIT_ACK;
													end if;
											
			when WAIT_NOT_ACK => 		if (ACK = '1') 	then
														NextState <= WAIT_NOT_ACK;
													else
														NextState <= WAIT_LOAD;
													end if;
		end case;
	end process;

-- Generate Outputs
OB_free <= '1' when (CurrentState = WAIT_LOAD)
				else '0';

W_reg <= '1' when (CurrentState = WAIT_NOT_LOAD)
					else '0';

D_val  <= '1' 	when (CurrentState = WAIT_ACK)
					else '0';


end behavioral;