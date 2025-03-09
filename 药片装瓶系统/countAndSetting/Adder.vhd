library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Adder is
    port (
        a : in unsigned(11 downto 0);
        b : in unsigned(11 downto 0);
        sum : out unsigned(11 downto 0)
    );
end entity Adder;

architecture Behavioral of Adder is
begin
    sum <= a + b;  -- ¼Ó·¨²Ù×÷
end architecture Behavioral;
