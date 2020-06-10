library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port( pcin: in std_logic_vector(31 downto 0);
		cPC: in std_logic;
		pcout: out std_logic_vector(31 downto 0));
end pc;

architecture arch_pc of pc is

	signal sig_pcout: std_logic_vector(31 downto 0) := (others => '0');

begin
	process is
	begin
		wait until rising_edge (cPC);
		sig_pcout <= pcin;
	end process;
	
	pcout <= sig_pcout;

end arch_pc;