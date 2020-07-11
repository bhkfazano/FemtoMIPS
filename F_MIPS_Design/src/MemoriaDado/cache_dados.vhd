library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_dados is
	port( clk, pronto, memRead, memWrite, write_atual: in std_logic;
		dadosin: in std_logic_vector(127 downto 0);
		ender_atual, endr, endw, dataw: in std_logic_vector(31 downto 0);
		pause_pipe, miss, write_en: out std_logic;
		dadosout, enderout, datao: out std_logic_vector(31 downto 0));
end cache_dados;

architecture arch_cache_dados of cache_dados is
	type data_type is array(0 to 255) of std_logic_vector(0 to 511);
	signal data: data_type := (others => (others => '0'));
	
	type tag_type is array(0 to 255) of std_logic_vector(0 to 1);
	signal tag: tag_type := (others => (others => '0'));
	
	signal valid: std_logic_vector(0 to 255) := (others => '0');
	
	signal data_aux: std_logic_vector(0 to 511) := (others => '0');
	signal data_pt1, data_pt2, data_pt3: std_logic_vector(127 downto 0) := (others => '0');
	
	signal wbuffer_data, wbuffer_ender: std_logic_vector(31 downto 0) := (others => '0');
	signal wbuffer_full: std_logic := '0';
	
	signal sig_pause_pipe, sig_miss, sig_write_en: std_logic := '0';
	signal sig_dadosout, sig_enderout, sig_datao: std_logic_vector(31 downto 0) := (others => '0');
	
begin
	process is
	begin
		wait until rising_edge (clk);
		wait for 0.05 ns;
		sig_datao <= (others => '0');
		if (to_integer(unsigned(endr)) < 65536 and memRead = '1') then
			sig_pause_pipe <= '1';
			if valid(to_integer(unsigned(endr(15 downto 8)))) = '1' and 
							tag(to_integer(unsigned(endr(15 downto 8)))) = endr(7 downto 6) then
				wait for 4.95 ns;
				data_aux <= data(to_integer(unsigned(endr(15 downto 8))));
				sig_datao <= data_aux(
						32*to_integer(unsigned(endr(5 downto 2))) to 32*to_integer(unsigned(endr(5 downto 2)))+31);
			else
				sig_miss <= '1';
				sig_enderout <= (31 downto 16 => '0') & endr(15 downto 6) & "000000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt1 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endr(15 downto 6) & "010000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt2 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endr(15 downto 6) & "100000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt3 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endr(15 downto 6) & "110000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data(to_integer(unsigned(endr(15 downto 8)))) <= data_pt1 & data_pt2 & data_pt3 & dadosin;
				valid(to_integer(unsigned(endr(15 downto 8)))) <= '1';
				tag(to_integer(unsigned(endr(15 downto 8)))) <= endr(7 downto 6);
				sig_miss <= '0';
				
				wait for 5 ns;
				data_aux <= data(to_integer(unsigned(endr(15 downto 8))));
				sig_datao <= data_aux(
						32*to_integer(unsigned(endr(5 downto 2))) to 32*to_integer(unsigned(endr(5 downto 2)))+31);
			end if;
			sig_pause_pipe <= '0';
		elsif (to_integer(unsigned(endw)) < 65536 and memWrite = '1') then
			sig_pause_pipe <= '1';
			if valid(to_integer(unsigned(endw(15 downto 8)))) /= '1' or 
							tag(to_integer(unsigned(endw(15 downto 8)))) /= endw(7 downto 6) then
				sig_miss <= '1';
				sig_enderout <= (31 downto 16 => '0') & endw(15 downto 6) & "000000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt1 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endw(15 downto 6) & "010000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt2 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endw(15 downto 6) & "100000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data_pt3 <= dadosin;
				sig_enderout <= (31 downto 16 => '0') & endw(15 downto 6) & "110000";
				
				if not (pronto = '0' and write_atual = '0' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '0' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				data(to_integer(unsigned(endw(15 downto 8)))) <= data_pt1 & data_pt2 & data_pt3 & dadosin;
				valid(to_integer(unsigned(endw(15 downto 8)))) <= '1';
				tag(to_integer(unsigned(endw(15 downto 8)))) <= endw(7 downto 6);
				sig_miss <= '0';
			end if;
			wait for 4.95 ns;
			data_aux <= data(to_integer(unsigned(endw(15 downto 8))));
			data_aux(32*to_integer(unsigned(endw(5 downto 2))) to 32*to_integer(unsigned(endw(5 downto 2)))+31) 
						<= dataw;
			data(to_integer(unsigned(endw(15 downto 8)))) <= data_aux;
			
			if wbuffer_full = '0' then
				wbuffer_ender <= endw;
				wbuffer_data <= dataw;
				wbuffer_full <= '1';
			else
				sig_miss <= '1';
				sig_enderout <= wbuffer_ender;
				sig_dadosout <= wbuffer_data;
				sig_write_en <= '1';
				
				if not (pronto = '0' and write_atual = '1' and ender_atual = sig_enderout) then
					wait until pronto = '0' and write_atual = '1' and ender_atual = sig_enderout;
				end if;
				
				if not (pronto = '1') then
					wait until pronto = '1';
				end if;
				
				sig_miss <= '0';
				sig_write_en <= '0';
				wbuffer_ender <= endw;
				wbuffer_data <= dataw;
			end if;
			sig_pause_pipe <= '0';
		end if;
	end process;
	
	pause_pipe <= sig_pause_pipe;
	miss <= sig_miss;
	write_en <= sig_write_en;
	dadosout <= sig_dadosout;
	enderout <= sig_enderout;
	datao <= sig_datao;
	
end arch_cache_dados;