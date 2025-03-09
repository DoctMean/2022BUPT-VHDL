library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity add is
  port (
         a,b : in std_logic_vector(3 downto 0);
         c : in std_logic;
         sum : out std_logic_vector (4 downto 0)
         );
end add;

architecture arc of add is
  begin
      sum <= ('0'&a)+b+c;
end arc;
