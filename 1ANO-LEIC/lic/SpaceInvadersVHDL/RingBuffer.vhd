LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity RingBuffer is
port(
	R: in std_logic;
	CLK : in std_logic;
	D: in std_logic_vector(3 downto 0);
	DAV: in std_logic;
	CTS: in std_logic;
	DAC: out std_logic;
	Wreg: out std_logic;
	Q: out std_logic_vector(3 downto 0)
);
end RingBuffer;

architecture structural of RingBuffer is

component RingBufferControl is
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
end component;

component MemoryAddressControl is 
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
end component;

component RAM is
	generic(
		ADDRESS_WIDTH : natural := 3;
		DATA_WIDTH : natural := 4
	);
	port(
		address : in std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
		wr: in std_logic;
		din: in std_logic_vector(DATA_WIDTH - 1 downto 0);
		dout: out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);
end component;

signal sq_full, sq_empty, sq_wr, sq_incPut, sq_incGet, sq_selPG: std_logic;
signal sq_A: std_logic_vector(2 downto 0);
begin

RingBufferControl_Inst0: RingBufferControl port map (
	R => R,
	DAV => DAV,
	CLK => CLK,
	CTS => CTS,
	full => sq_full,
	empty => sq_empty,
	Wr => sq_wr,
	Wreg => Wreg,
	DAC => DAC,
	incPut => sq_incPut,
	incGet => sq_incGet,
	selPG => sq_selPG
);

MemoryAddressControl_Inst0: MemoryAddressControl port map (
	R => R,
	putget => sq_selPG,
	incPut => sq_incPut,
	incGet => sq_incGet,
	CLK => CLK,
	full => sq_full,
	empty => sq_empty,
	A => sq_A
);

RAM_Inst0: RAM port map (
	address => sq_A,
	wr => sq_wr,
	din => D,
	dout => Q
);

end structural;