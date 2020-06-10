library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- ARRUMAR MUITO! MÁQUINA DE ESTADOS! (aguardando resp do prof.)

entity memoria_principal is
	port( enable, rw: in std_logic;
		pronto: out std_logic;
		ender: in std_logic_vector(31 downto 0);
		dados: inout std_logic_vector(31 downto 0));
end memoria_principal;

architecture arch_memoria_principal of memoria_principal is
	type data is array(16383 downto 0) of std_logic_vector(31 downto 0);
	
	signal data_mem: data := (others => (others => '0'));
	signal sig_pronto: std_logic := '0';
begin
	process(rw, ender) is
	begin
		sig_pronto <= '0';
		if (enable = '1' and to_integer(unsigned(ender)) < 16384) then
			if (rw = '1') then
				dados <= data_mem(to_integer(unsigned(ender))) after 40 ns;
			else	  
				data_mem(to_integer(unsigned(ender))) <= dados after 40 ns;
			end if;
			sig_pronto <= '1' after 40 ns;
			while (sig_pronto = '0') loop
				
			end loop;
		end if;
	end process;
	
	pronto <= sig_pronto;

end arch_memoria_principal;