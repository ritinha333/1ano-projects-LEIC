library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Parity_Check is
port( data: in std_logic;		--- Bit de dados recebidos 
		init: in std_logic;		--- Sinal para iniciar a verificação de paridade
		clk: in std_logic;		
		err: out std_logic		--- Saída de erro que indica se é ímpar ou seja xor de tudo
);

end Parity_Check;

architecture ARQ_Parity_Check of Parity_Check is

component FFD
PORT(
	CLK : in std_logic;
	RESET : in STD_LOGIC;
	SET : in std_logic;
	D : IN STD_LOGIC;
	EN : IN STD_LOGIC;
	Q : out std_logic
);
end component;

signal s_out_ffd, s_d: std_logic;

BEGIN

s_d <= data xor s_out_ffd;

Flip_Flop_Inst0: FFD port map(
	CLK => clk, 
	reset => init, 
	set => '0', 
	D => s_d, 
	EN => '1', 
	Q => s_out_ffd
);


err <= s_out_ffd;

end ARQ_Parity_Check;

