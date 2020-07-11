library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_10ns is
	port( clk: out std_logic);
end clock_10ns;

architecture arch_clock_10ns of clock_10ns is

	signal sig_clk: std_logic := '0';

begin
	process is
	begin
		sig_clk <= not sig_clk;
		wait for 5 ns;
	end process;
	
	clk <= sig_clk;

end arch_clock_10ns;