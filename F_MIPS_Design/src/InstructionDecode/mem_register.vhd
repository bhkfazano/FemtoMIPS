library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem_register is
	port( clk: in std_logic;
		endA, endB, endW: in std_logic_vector(4 downto 0);
		dataW: in std_logic_vector(31 downto 0);
		regWrite: in std_logic;
		dataA, dataB: out std_logic_vector(31 downto 0));
end mem_register;

architecture arch_mem_register of mem_register is
	type data is array(31 downto 0) of std_logic_vector(31 downto 0);
	
	signal data_mem: data := (others => (others => '0'));
	
	signal sig_dataA, sig_dataB: std_logic_vector(31 downto 0) := (others => '0');
begin
	process is
	begin
		wait until rising_edge (regWrite);
		wait for 0.1 ns;
		if endw /= "00000" then
			wait for 3.9 ns;
			data_mem(to_integer(unsigned(endW))) <= dataw;
		end if;
	end process;
	
	process is
	begin
		wait on clk;
		wait for 0.1 ns;
		if clk = '0' then
			wait for 3.9 ns;
			sig_dataA <= data_mem(to_integer(unsigned(endA)));
			sig_dataB <= data_mem(to_integer(unsigned(endB)));
		end if;
	end process;
	
	dataA <= sig_dataA;
	dataB <= sig_dataB;
	
end arch_mem_register;