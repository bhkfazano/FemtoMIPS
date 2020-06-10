library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc1 is
	port( contin: in std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0);	 
		cMD: out std_logic_vector(2 downto 0);
		cEX: out std_logic_vector(3 downto 0));
end uc1;