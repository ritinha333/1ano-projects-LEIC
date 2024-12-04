LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity MemoryAddressControl is 
port(
		R: in std_logic;
		putget: in std_logic;
		incPut: in std_logic;
		incGet: in std_logic;
		CLK: in std_logic;
		full: out std_logic;
		empty: out std_logic;
		A: out std_logic_vector(2 downto 0)
);

end MemoryAddressControl;

architecture structural of MemoryAddressControl is

component Compare4 is
port (
	terminalValue: in std_logic_vector(3 downto 0);
	Q: in std_logic_vector(3 downto 0);
	TC: out std_logic
);
end component;

component Counter4 is
port (
	OP: in std_logic;
	PL: in std_logic;
	CE: in std_logic;
	CLK: in std_logic;
	R: in std_logic;
	terminalValue: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0);
	TC: out std_logic 								
);
end component;

signal s_enablecounter, s_TC_put, s_TC_get, s_TC_el, s_OP, s_PL_elems: std_logic:='0';
signal s_IDX_put, s_IDX_get, s_num_elem: std_logic_vector(3 downto 0);

begin

Counter4_INS0: Counter4 port map(
	OP => '0',
	PL => s_TC_put,
	CE => incPut,
	CLK => CLK,
	Q => s_IDX_put,
	terminalValue => "0111",
	TC => s_TC_put,
	R => R
);

Counter4_INS1: Counter4 port map(
	OP => '0',
	PL => s_TC_get,
	CE => incGet,
	CLK => CLK,
	Q => S_IDX_get,
	terminalValue => "0111",
	TC => s_TC_get,
	R => R
);

s_PL_elems <= s_TC_el and not s_OP;
s_enablecounter <= incGet or incPut;
s_OP <= not(incPut) or incGet;

Counter4_INS2: Counter4 port map(
	terminalValue => "1000",
	TC => s_TC_el,
	OP => s_OP,
	PL => s_PL_elems,
	CE => s_enablecounter,
	Q => s_num_elem,
	CLK => CLK,
	R => R
);

Compare4_INS0: Compare4 port map(
	Q => s_num_elem,
	terminalValue => "1000",
	TC => full
);

Compare4_INS1: Compare4 port map(
	Q => s_num_elem,
	terminalValue => "0000",
	TC => empty
);

-- TO-DO: Usar MUX
A(2) <= (not putget and s_IDX_get(2)) or (putget and s_IDX_put(2));
A(1) <= (not putget and s_IDX_get(1)) or (putget and s_IDX_put(1));
A(0) <= (not putget and s_IDX_get(0)) or (putget and s_IDX_put(0));

end structural;