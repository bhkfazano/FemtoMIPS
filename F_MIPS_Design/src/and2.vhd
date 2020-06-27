library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity and2 is
	port( in1, in2: in std_logic;
		out1: out std_logic);
end and2;

architecture arch_and2 of and2 is
begin
	out1 <= in1 and in2;
	
end arch_and2;