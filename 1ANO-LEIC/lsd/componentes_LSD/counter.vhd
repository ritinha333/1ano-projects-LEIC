library ieee;
use ieee.std_logic_1164.all;

entity counter is
	port
	(
	PL: in std_logic;
	CE: in std_logic;
	Datain: in std_logic_vector(3 downto 0);
	terminalValue: in std_logic_vector(3 downto 0);
	CLK :in std_logic;
	Reset :in std_logic;
	S :out std_logic_vector(3 downto 0);
	TC: out std_logic
	);
end counter;

architecture structural of counter is

component adder4bit is
port (
	A :in std_logic_vector(3 downto 0);
	B :in std_logic_vector(3 downto 0);
	Ci :in std_logic;
	S :out std_logic_vector(3 downto 0);
	Co :out std_logic
);
end component;

component Registo is
port (
	D :in std_logic_vector(3 downto 0);
	E: in std_logic;
	clock : in std_logic;
	reset : in std_logic;
	Q : out std_logic_vector(3 downto 0)
);
end component;

component OP_MUX2_4bits is
port(
	A: in std_logic_vector(3 downto 0);
	B: in std_logic_vector (3 downto 0);
	S: in std_logic;
	R: out std_logic_vector(3 downto 0)
	);
end component;

signal MUXoutput1 :std_logic_vector(3 downto 0);
signal R :std_logic_vector(3 downto 0):="0000";
signal Adderoutput :std_logic_vector(3 downto 0);
signal MUXoutput :std_logic_vector(3 downto 0);
signal D: std_logic_vector(3 downto 0);

begin

U0 :OP_MUX2_4bits port map (
	A=>"0000", 
	B=>"0001", 
	S=>CE, 
	R=>MUXoutput1);
	
U1 :adder4bit port map (
	A=>R, 
	B=>MUXoutput1, 
	Ci=>'0', 
	S=>Adderoutput);
	
U2 :OP_MUX2_4bits port map (
	A=>Adderoutput, 
	B=>Datain, 
	S=>PL, 
	R=>MUXoutput);
	
U3 :Registo port map (
	D=>MUXoutput, 
	reset=>Reset, 
	E=> CE, 
	clock=>CLK, 
	Q=>R);
	
	D <= R XOR terminalValue;
   TC <= not (D(3) or D(2) or D(1) or D(0));
	S <= R;
end structural;
