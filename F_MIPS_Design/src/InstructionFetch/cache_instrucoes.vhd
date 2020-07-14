library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_instrucoes is
	port( write_atual: in std_logic;
		ender_atual, end1: in std_logic_vector(31 downto 0);
		dadosin: in std_logic_vector(127 downto 0);
		pronto, clkC: in std_logic;
		freeze_count: out std_logic;
		enderout, dout, cont_hits, cont_misses, cont_memaccess: out std_logic_vector(31 downto 0));
end cache_instrucoes;

architecture arch_cache_instrucoes of cache_instrucoes is
	type data_type is array(0 to 255) of std_logic_vector(0 to 511);
	signal data: data_type := (others => (others => '0'));
	
	type tag_type is array(0 to 255) of std_logic_vector(0 to 1);
	signal tag: tag_type := (others => (others => '0'));
	
	signal valid: std_logic_vector(0 to 255) := (others => '0');
	
	signal data_aux: std_logic_vector(0 to 511) := (others => '0');
	signal data_pt1, data_pt2, data_pt3: std_logic_vector(127 downto 0) := (others => '0');
	
	signal sig_freeze_count: std_logic := '0';
	signal sig_enderout, sig_dout: std_logic_vector(31 downto 0) := (others => '0');
	
	signal sig_cont_hits, sig_cont_misses, sig_cont_memaccess: std_logic_vector(31 downto 0) := (others => '0');
	
begin
	process is
	begin
		wait until rising_edge (clkC);
		wait for 0.1 ns;
		sig_dout <= (others => '0');
		if (to_integer(unsigned(end1)) < 65536) then
			sig_freeze_count <= '1';
			if valid(to_integer(unsigned(end1(15 downto 8)))) = '1' and 
							tag(to_integer(unsigned(end1(15 downto 8)))) = end1(7 downto 6) then
				sig_cont_hits <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_hits)) + 1, 32));
				wait for 4.9 ns;
				data_aux <= data(to_integer(unsigned(end1(15 downto 8))));
				sig_dout <= data_aux(
						32*to_integer(unsigned(end1(5 downto 2))) to 32*to_integer(unsigned(end1(5 downto 2)))+31);
			else
				sig_cont_misses <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_misses)) + 1, 32));
				sig_enderout <= (31 downto 16 => '0') & end1(15 downto 6) & "000000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt1 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & end1(15 downto 6) & "010000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt2 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & end1(15 downto 6) & "100000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt3 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & end1(15 downto 6) & "110000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				sig_cont_memaccess <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_memaccess)) + 4, 32));
				data(to_integer(unsigned(end1(15 downto 8)))) <= data_pt1 & data_pt2 & data_pt3 & dadosin;
				valid(to_integer(unsigned(end1(15 downto 8)))) <= '1';
				tag(to_integer(unsigned(end1(15 downto 8)))) <= end1(7 downto 6);
				
				wait for 5 ns;
				data_aux <= data(to_integer(unsigned(end1(15 downto 8))));
				sig_dout <= data_aux(
						32*to_integer(unsigned(end1(5 downto 2))) to 32*to_integer(unsigned(end1(5 downto 2)))+31);
			end if;
			sig_freeze_count <= '0';
		end if;
	end process;
	
	freeze_count <= sig_freeze_count;
	enderout <= sig_enderout;
	dout <= sig_dout;
	cont_hits <= sig_cont_hits;
	cont_misses <= sig_cont_misses;
	cont_memaccess <= sig_cont_memaccess;
	
end arch_cache_instrucoes;