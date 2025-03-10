LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY set_hour IS
    PORT (

        set_hour : IN STD_LOGIC;
        set : IN STD_LOGIC;
     
        clk : IN STD_LOGIC;
        high_num : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        low_num : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        in_high_num : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        in_low_num : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        alarm_hour: IN STD_LOGIC;
        alarm_high_num : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        alarm_low_num : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END set_hour;

ARCHITECTURE func OF set_hour IS
    SIGNAL tmp_low, tmp_high : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL tmp1_low, tmp1_high : STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    PROCESS ( set, clk,set_hour,alarm_hour)
    BEGIN
--        IF(clr = '1') THEN 
--            tmp_low <= "0000";
--            tmp_high <= "0000";
--        ELSE 
           if(set = '1'  And set_hour='1') THEN             
                tmp_low <= in_low_num;
                tmp_high<= in_high_num; 
                if(in_high_num>2) then
                tmp_high<="0000";
                end if;
                if(in_low_num>4 AND in_high_num=2) then
                tmp_low<="0000";
                end if; 
                if(in_low_num>9) then
                tmp_low<="0000";
                end if;   
           elsif(set = '1'  And alarm_hour='1') then    
                tmp1_low <= in_low_num;
                tmp1_high<= in_high_num;           
           END IF;
--        END if;
    END PROCESS;
    low_num<=tmp_low;
    high_num<=tmp_high;
    alarm_low_num<=tmp1_low;
    alarm_high_num<=tmp1_high;
END func;