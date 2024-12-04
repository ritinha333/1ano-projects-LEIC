LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY LUcirc IS
    PORT(
        X: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Op: IN STD_LOGIC;
        R: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END LUcirc;

ARCHITECTURE arq_LUcirc OF LUcirc IS
    COMPONENT ORL4
        PORT(
            A: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            B: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            R: OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT XNORL4
        PORT(
            A, B: IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            R: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MUX4
        PORT(
            A: IN STD_LOGIC;
            B: IN STD_LOGIC;
            S: IN STD_LOGIC;
            Y: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;
	

SIGNAL rOF, rXF: STD_LOGIC;
SIGNAL xA, yB: STD_LOGIC_VECTOR (3 DOWNTO 0);
SIGNAL res: STD_LOGIC;

BEGIN

    xA <= X;
    yB <= Y;

    UORL4: ORL4 PORT MAP(
        A => xA,
        B => yB,
        R => rOF
    );

    UXNORL4: XNORL4 PORT MAP(
        A => xA,
        B => yB,
        R => rXF
    );

    UMUX4: MUX4 PORT MAP(
        A => rOF,
        B => rXF,
        S => Op,
        Y => res
    );

    R <= res;

END ARCHITECTURE;
