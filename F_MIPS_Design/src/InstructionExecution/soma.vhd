library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma is
	port( in1, in2: in std_logic_vector(31 downto 0);
		out1: out std_logic_vector(31 downto 0));
end soma;

architecture arch_soma of soma is
begin
	out1 <= std_logic_vector(to_signed(to_integer(signed(in1)) + to_integer(signed(in2)), out1'length));
	
end arch_soma;