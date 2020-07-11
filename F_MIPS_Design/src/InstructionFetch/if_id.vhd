library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity if_id is
	port( pause, bubb: in std_logic;
		npc, inst: in std_logic_vector(31 downto 0);
		cIF_ID: in std_logic;
		out1: out std_logic_vector(63 downto 0));
end if_id;

architecture arch_if_id of if_id is

	signal sig_out1: std_logic_vector(63 downto 0) := (others => '0');

begin
	process is
	begin
		wait until rising_edge (cIF_ID);
		if pause = '0' then
			if bubb = '1' then
				sig_out1 <= (others => '0');
			else
				sig_out1 <= inst & npc;
			end if;
		end if;
	end process;
	
	out1 <= sig_out1;

end arch_if_id;