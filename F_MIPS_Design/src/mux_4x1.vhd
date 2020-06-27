library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4x1 is
	generic( WIDTH: integer);
	port( in1, in2, in3, in4: in std_logic_vector(WIDTH-1 downto 0);
		sel: in std_logic_vector(1 downto 0);
		out1: out std_logic_vector(WIDTH-1 downto 0));
end mux_4x1;

architecture arch_mux_4x1 of mux_4x1 is
	signal sig_out1: std_logic_vector(WIDTH-1 downto 0) := (others => '0');
begin
	sig_out1 <= in1 when sel = "00" else
		in2 when sel = "01" else
		in3 when sel = "10" else
		in4 when sel = "11" else
		(others => '0');
	out1 <= sig_out1;

end arch_mux_4x1;