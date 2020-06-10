library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity c_ula is
	port( in1: in std_logic_vector(5 downto 0);
		ulaop: in std_logic_vector(1 downto 0);
		out1: std_logic_vector(2 downto 0));
end c_ula;