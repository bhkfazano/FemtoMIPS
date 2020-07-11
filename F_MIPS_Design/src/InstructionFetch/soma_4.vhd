library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_4 is
	port( in1: in std_logic_vector(31 downto 0);
		out1: out std_logic_vector(31 downto 0));
end soma_4;

architecture arch_soma_4 of soma_4 is
begin
	out1 <= std_logic_vector(to_unsigned(to_integer(unsigned(in1)) + 4, out1'length));
	
end arch_soma_4;