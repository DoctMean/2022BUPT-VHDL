LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ring IS
    PORT (
        clk, hour, clk_2 : IN STD_LOGIC;
        cdf : IN STD_LOGIC;
        out_high : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        out_low : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        out1_high : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        out1_low : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        alarm_min : IN STD_LOGIC;
        alarm_hour : IN STD_LOGIC;
        qout : OUT STD_LOGIC);
END ring;

ARCHITECTURE func OF ring IS
--    SIGNAL temp : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL flag : STD_LOGIC;

	SIGNAL ala : STD_LOGIC;
	
BEGIN

    PROCESS (clk_2)
    BEGIN

		ala<= alarm_min AND alarm_hour;
        flag <=  hour or ala;
        IF (flag = '1' or cdf = '1') THEN
            IF (out1_low < 6 AND out1_high = 0 AND out1_low(0) = '0' ) THEN
                qout <= clk_2;
            ELSE
                qout <= '0';
            END IF;
        END IF;
    END PROCESS;

END func;