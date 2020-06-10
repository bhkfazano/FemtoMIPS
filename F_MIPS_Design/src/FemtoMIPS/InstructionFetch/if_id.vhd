library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id is
	port( npc, inst: in std_logic_vector(31 downto 0);
		cIF_ID: in std_logic;
		out1: out std_logic_vector(63 downto 0));
end if_id;

architecture arch_if_id of if_id is

	signal sig_out1: std_logic_vector(63 downto 0) := 
			"0010000001000010000000000000000000000000000000000000000000000100";

begin
	process is
	begin
		wait until rising_edge (cIF_ID);
		sig_out1 <= inst & npc;
	end process;
	
	out1 <= sig_out1;

end arch_if_id;