library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2x1 is
	generic( WIDTH: integer);
	port( in1, in2: in std_logic_vector(WIDTH-1 downto 0);
		sel: in std_logic;
		out1: out std_logic_vector(WIDTH-1 downto 0));
end mux_2x1;

architecture arch_mux_2x1 of mux_2x1 is
begin
	out1 <= in1 when sel = '0' else
		in2 when sel = '1' else
		(others => '0');

end arch_mux_2x1;