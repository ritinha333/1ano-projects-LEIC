LIBRARY IEEE;
use IEEE.std_logic_1164.all;

entity Key_Control_tb is
end Key_Control_tb;

architecture behavioral of Key_Control_tb is

component Key_Control is
port(
	RESET: in std_logic;
	CLK : in std_logic;
	K_press: in std_logic;
	K_ack: in std_logic;
	K_val: out std_logic;
	K_scan: out std_logic_Vector(1 downto 0)
);
end component;

--UUT signals
constant MCLK_PERIOD: time := 20ns; -- 20 ns;
constant MCLK_HALF_PERIOD: time := MCLK_PERIOD / 2;

signal RESET_tb: std_logic;
signal CLK_tb: std_logic;
signal K_press_tb: std_logic;
signal K_ack_tb: std_logic;
signal K_val_tb: std_logic;
signal K_scan_tb: std_logic_vector(1 downto 0);

begin

---Unit Under Test
UUT: Key_Control
port map(RESET => RESET_tb,
			CLK => CLK_tb,
			K_press => K_press_tb,
			K_ack => K_ack_tb,
			K_val => K_val_tb,
			K_scan => K_scan_tb
);

clk_gen: process
begin
	CLK_tb <= '0';
	wait for MCLK_HALF_PERIOD;
	CLK_tb <= '1';
	wait for MCLK_HALF_PERIOD;
end process;


stimulus: process
begin

--fazer reset ao módulo
RESET_tb <= '1';
wait for MCLK_PERIOD*2;

--reset a zero
RESET_tb <= '0';
wait for MCLK_PERIOD*2;

-- Com K_press_tb = '0' observar a saída K_scan(1) = '1' e mudança de estado
K_press_tb <= '0';
wait for MCLK_PERIOD*2;

-- Com K_press_tb = '1' observar a saída K_scan(0) = '1' e mudança de estado

K_press_tb <= '1';
wait for MCLK_PERIOD*2;

-- Com K_ack_tb = '0' observar o estado e o sinal K_val ativo a '1' e mudança de estado

K_ack_tb <= '0';
wait for MCLK_PERIOD*2;

-- Com K_ack_tb = '1' observar a mudança de estado

K_ack_tb <= '1';
wait for MCLK_PERIOD*2;

-- Novamente teste ao K_ack_tb de modo a ter a certeza que o sistema está livre para o varrimento
-- K_ack_tb = '1' observar a mudança de estado

K_ack_tb <= '1';
wait for MCLK_PERIOD*2;

-- Com K_ack_tb = '0' observar o estado de modo a ter a certeza do acknolegment

K_ack_tb <= '0';
wait for MCLK_PERIOD*2;

-- Com K_press_tb = '0' significa que ainda está a ser pressionado uma tecla, apenas quando houver uma nova pressão 
-- é que é desejado repetir o varrimento.

K_press_tb <= '1';
wait for MCLK_PERIOD*2;

-- Com K_press_tb = '1' significa que o módulo está pronto para varrer uma nova tecla

K_press_tb <= '0';
wait for MCLK_PERIOD*2;


wait;

end process;

end architecture;





