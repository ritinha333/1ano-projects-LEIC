LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY REG IS
    PORT (
        d : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        clk, en, res: IN STD_LOGIC;
        q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END REG;

ARCHITECTURE REG_arch OF REG IS
    COMPONENT FFD IS
        PORT (
            CLK, RESET, SET, D, EN : IN STD_LOGIC;
            Q : OUT STD_LOGIC);
    END COMPONENT;

BEGIN
    U0 : FFD PORT MAP(CLK => clk, D => d(0), Q => q(0), SET => '0', RESET => res, EN => en);
    U1 : FFD PORT MAP(CLK => clk, D => d(1), Q => q(1), SET => '0', RESET => res, EN => en);
    U2 : FFD PORT MAP(CLK => clk, D => d(2), Q => q(2), SET => '0', RESET => res, EN => en);
    U3 : FFD PORT MAP(CLK => clk, D => d(3), Q => q(3), SET => '0', RESET => res, EN => en);

END REG_arch;