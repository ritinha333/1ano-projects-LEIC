LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Key_Control is
port(
	RESET: in std_logic;
	CLK : in std_logic;
	K_press: in std_logic;
	K_ack: in std_logic;
	K_val: out std_logic;
	K_scan: out std_logic_Vector(1 downto 0)
);
end Key_Control;

architecture behavioral of Key_Control is

type KEY_STATE is (WAIT_KEY_PRESS, WAIT_KEY_ACK, WAIT_NOT_KEY_ACK, WAIT_NOT_KEY_PRESS);

signal CurrentState, NextState: KEY_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_KEY_PRESS when RESET = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, K_press, K_ack)
	begin
		case CurrentState is
			when WAIT_KEY_PRESS 		=> 	if (K_press = '1') 	then
														NextState <= WAIT_KEY_ACK;
													else
														NextState <= WAIT_KEY_PRESS;
													end if;
									
			when WAIT_KEY_ACK 		=> 	if (K_ack = '1') 		then
														NextState <= WAIT_NOT_KEY_ACK;
													else
														NextState <= WAIT_KEY_ACK;
													end if;
			
			when WAIT_NOT_KEY_ACK 	=> 	if (K_ack = '1') 		then
														NextState <= WAIT_NOT_KEY_ACK;
													else
														NextState <= WAIT_NOT_KEY_PRESS;
													end if;
											
			when WAIT_NOT_KEY_PRESS => 	if (K_press = '1') 	then
														NextState <= WAIT_NOT_KEY_PRESS;
													else
														NextState <= WAIT_KEY_PRESS;
													end if;
		end case;
	end process;
	
-- Generate Outputs
K_scan(1) <= '1' 	when (CurrentState = WAIT_KEY_PRESS and K_press = '0' )
					else '0';

K_scan(0) <= '1' 	when (CurrentState = WAIT_KEY_PRESS and K_press = '1' )
					else '0';

K_val  <= '1' 	when (CurrentState = WAIT_KEY_ACK)
					else '0';


end behavioral;