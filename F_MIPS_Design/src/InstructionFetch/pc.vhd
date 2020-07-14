library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port( end_prog, cont_en: in std_logic;
		pcin: in std_logic_vector(31 downto 0);
		cPC: in std_logic;
		pcout: out std_logic_vector(31 downto 0));
end pc;

architecture arch_pc of pc is

	signal sig_pcout: std_logic_vector(31 downto 0) := (others => '0');
	signal sig_end_prog: std_logic := '0';

begin
	process is
	begin
		wait until rising_edge (cPC);
		if cont_en = '1' and sig_end_prog = '0' then
			sig_pcout <= pcin;
		end if;
	end process;
	
	process is
	begin
		wait on end_prog;--reset!
		sig_end_prog <= end_prog;
	end process;
	
	pcout <= sig_pcout;

end arch_pc;