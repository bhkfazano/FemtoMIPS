library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_principal is
	port( enable, rw: in std_logic;
		pronto: out std_logic;
		ender: in std_logic_vector(31 downto 0);
		dados: inout std_logic_vector(31 downto 0));
end memoria_principal;

architecture arch_memoria_principal of memoria_principal is
	type data is array(0 to 65535) of std_logic_vector(7 downto 0);
	signal data_mem: data := (others => (others => '0'));
	
	signal sig_pronto: std_logic := '0';
	signal last_rw: std_logic := '1';
	signal last_ender: std_logic_vector(31 downto 0) := (others => '1');
	
begin
	process is
	begin
		wait until rw /= last_rw or ender /= last_ender;
		sig_pronto <= '0';
		last_rw <= rw;
		last_ender <= ender;
		if (enable = '1' and to_integer(unsigned(last_ender)) < 65536) then
			wait for 40 ns;
			if (last_rw = '1') then
				dados <= data_mem(to_integer(unsigned(last_ender))) & data_mem(to_integer(unsigned(last_ender)+1)) & 
					data_mem(to_integer(unsigned(last_ender)+2)) & data_mem(to_integer(unsigned(last_ender)+3));
			else
				data_mem(to_integer(unsigned(last_ender))) <= dados(31 downto 24);
				data_mem(to_integer(unsigned(last_ender)+1)) <= dados(23 downto 16);
				data_mem(to_integer(unsigned(last_ender)+2)) <= dados(15 downto 8);
				data_mem(to_integer(unsigned(last_ender)+3)) <= dados(7 downto 0);
			end if;
			sig_pronto <= '1';
		end if;
	end process;
	
	pronto <= sig_pronto;

end arch_memoria_principal;