library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	port( in1: in std_logic_vector(15 downto 0);
		signext_enable: in std_logic;
		out1: out std_logic_vector(31 downto 0));
end sign_extend;

architecture arch_sign_extend of sign_extend is
begin
	out1 <= (31 downto 16 => in1(15)) & in1 when signext_enable = '1' else
		(31 downto 16 => '0') & in1;
	
end arch_sign_extend;