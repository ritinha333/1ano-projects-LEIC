LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity RingBufferControl is
port(
	R: in std_logic;
	DAV: in std_logic;
	CLK : in std_logic;
	CTS: in std_logic;
	full: in std_logic;
	empty: in std_logic;
	Wr: out std_logic;
	Wreg: out std_logic;
	DAC: out std_logic;
	incPut: out std_logic;
	incGet: out std_logic;
	selPG: out std_logic
);
end RingBufferControl;

architecture behavioral of RingBufferControl is

type RING_STATE is (WAIT_ACTION, UPDATE_SELPG, SAVE_KEY, UPDATE_INCPUT, WAIT_NOT_DAV, SEND_KEY, UPDATE_INCGET, WAIT_NOT_CTS);

signal CurrentState, NextState: RING_STATE;

begin

-- Flip-Flop's
CurrentState <= WAIT_ACTION when R = '1' else NextState when rising_edge(CLK);

-- Generate Next State
GenerateNextState:
process (CurrentState, DAV, CTS, full, empty)
	begin
		case CurrentState is
			when WAIT_ACTION	 		=> 	if (DAV = '1' and full = '0') 	then
														NextState <= UPDATE_SELPG;
													elsif (CTS = '1' and empty = '0')	then
														NextState <= SEND_KEY;
													else
														NextState <= WAIT_ACTION;
													end if;
			
			when UPDATE_SELPG			=> 	NextState <= SAVE_KEY;
			
			when SAVE_KEY 				=> 	NextState <= UPDATE_INCPUT;
			
			when UPDATE_INCPUT		=> 	NextState <= WAIT_NOT_DAV;

			when WAIT_NOT_DAV			=>		if (DAV = '0') then
														NextState <= WAIT_ACTION;
													else
														NextState <= WAIT_NOT_DAV;
													end if;

			when SEND_KEY 				=> 	NextState <= UPDATE_INCGET;
			
			when UPDATE_INCGET		=>		NextState <= WAIT_NOT_CTS;

			when WAIT_NOT_CTS			=>		if (CTS = '0') then
														NextState <= WAIT_ACTION;
													else
														NextState <= WAIT_NOT_CTS;
													end if;

		end case;
	end process;

-- Generate Outputs
selPG <= '1' 	when (CurrentState = SAVE_KEY or CurrentState = UPDATE_SELPG) else '0';
Wr 	<= '1' 	when (CurrentState = SAVE_KEY) else '0';
incPut<= '1' 	when (CurrentState = UPDATE_INCPUT) else '0';

DAC 	<= '1' 	when (CurrentState = WAIT_NOT_DAV) else '0';

incGet<= '1' 	when (CurrentState = UPDATE_INCGET) else '0';
Wreg 	<= '1' 	when (CurrentState = SEND_KEY) else '0';

end behavioral;