library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock_10ns is
	port( clk: out std_logic;
		cont_cycles: out std_logic_vector(31 downto 0));
end clock_10ns;

architecture arch_clock_10ns of clock_10ns is

	signal sig_clk: std_logic := '0';
	signal sig_cont_cycles: std_logic_vector(31 downto 0) := (others => '0');

begin
	process is
	begin
		sig_clk <= '1';
		sig_cont_cycles <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_cycles)) + 1, 32));
		wait for 5 ns;
		sig_clk <= '0';
		wait for 5 ns;
	end process;
	
	clk <= sig_clk;
	cont_cycles <= sig_cont_cycles;

end arch_clock_10ns;