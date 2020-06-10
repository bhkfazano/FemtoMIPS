library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_register is
	port( endA, endB, endW: in std_logic_vector(4 downto 0);
		dataW: in std_logic_vector(31 downto 0);
		regWrite: in std_logic;
		dataA, dataB: out std_logic_vector(31 downto 0));
end mem_register;

architecture arch_mem_register of mem_register is
	type data is array(31 downto 0) of std_logic_vector(31 downto 0);
	
	signal data_mem: data := (others => (others => '0'));
begin
	process is
	begin
		wait until rising_edge (regWrite);
		data_mem(to_integer(unsigned(endW))) <= dataW;
	end process;
	
	dataA <= data_mem(to_integer(unsigned(endA)));
	dataB <= data_mem(to_integer(unsigned(endB)));

end arch_mem_register;