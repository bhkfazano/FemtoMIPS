library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_left_2 is
	port( in1: in std_logic_vector(31 downto 0);
		out1: out std_logic_vector(31 downto 0));
end shift_left_2;

architecture arch_shift_left_2 of shift_left_2 is
begin
	out1 <= in1(29 downto 0) & "00";
	
end arch_shift_left_2;