LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY AdderSubtractor IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CBi, OPau : IN STD_LOGIC;
        S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        B3, CBo : OUT STD_LOGIC);
END AdderSubtractor;

ARCHITECTURE arch_AdderSubtractor OF AdderSubtractor IS

    COMPONENT adder
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Ci : IN STD_LOGIC;
            S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Co : OUT STD_LOGIC);

    END COMPONENT;

    SIGNAL bx0, bx1, bx2, bx3, cx, cbx, Cox : STD_LOGIC;

BEGIN

    bx0 <= (B(0) XOR OPau);
    bx1 <= (B(1) XOR OPau);
    bx2 <= (B(2) XOR OPau);
    bx3 <= (B(3) XOR OPau);
    cx <= (CBi XOR OPau);

    CBo <= (Cox XOR OPau);
    B3 <= (bx3);

    U0 : adder PORT MAP(A => A, B(0) => bx0, B(1) => bx1, B(2) => bx2, B(3) => bx3, Ci => cx, S => S, Co => Cox);

END arch_AdderSubtractor;