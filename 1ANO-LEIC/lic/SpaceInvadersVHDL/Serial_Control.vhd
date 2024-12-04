LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Serial_Control is
port(
	RESET: in std_logic;
	CLK : in std_logic;
	LCDsel: in std_logic;
	accept: in std_logic;
	dFlag: in std_logic;
	pFlag: in std_logic;
	RXerror: in std_logic;
	DXval: out std_logic;
	init: out std_logic;
	wr: out std_logic
);
end Serial_Control;

architecture behavioral of Serial_Control is

type SERIAL_STATE is (WAIT_EMITTER, WAIT_REGISTRATION, WAIT_PARITY, WAIT_ACCEPT, WAIT_NOT_ACCEPT);

signal CurrentState, NextState: SERIAL_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_EMITTER when RESET = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, LCDsel, accept, dFlag, pFlag, RXerror)
	begin
		case CurrentState is
			when WAIT_EMITTER 		=> 	if (LCDsel = '1') 	then
														NextState <= WAIT_EMITTER;
													else
														NextState <= WAIT_REGISTRATION;
													end if;
									
			when WAIT_REGISTRATION 	=> 	if (LCDsel = '1')		then
														NextState <= WAIT_EMITTER;
													elsif (dFlag = '1') 	then 
														NextState <= WAIT_PARITY;
													else 
														NextState <= WAIT_REGISTRATION;
													end if;
			
			when WAIT_PARITY 	=> 			if (LCDsel = '0') 	then
														NextState <= WAIT_PARITY;
													elsif (pFlag = '0') 	then
														NextState <= WAIT_EMITTER;
													elsif (RXerror = '1') 	then
														NextState <= WAIT_EMITTER;
													else 
														NextState <= WAIT_ACCEPT;
													end if;
											
			when WAIT_ACCEPT => 				if (accept = '1') 	then
														NextState <= WAIT_NOT_ACCEPT;
													else
														NextState <= WAIT_ACCEPT;
													end if;
			
			when WAIT_NOT_ACCEPT =>			if	(accept = '1')		then 
														NextState <= WAIT_NOT_ACCEPT;
													else
														NextState <= WAIT_EMITTER;
													end if;
		end case;
	end process;

-- Generate Outputs
init <= '1' when (CurrentState = WAIT_EMITTER)
				else '0';

wr <= '1' when (CurrentState = WAIT_REGISTRATION)
					else '0';

DXval  <= '1' 	when (CurrentState = WAIT_ACCEPT)
					else '0';


end behavioral;