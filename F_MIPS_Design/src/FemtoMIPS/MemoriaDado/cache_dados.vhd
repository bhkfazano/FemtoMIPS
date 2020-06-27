library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity cache_dados is
	port( clk: in std_logic;
		endr, endw, dataw: in std_logic_vector(31 downto 0);
		memRead, memWrite: in std_logic;		
		datao: out std_logic_vector(31 downto 0));
end cache_dados;

architecture arch_cache_dados of cache_dados is
	type data is array(0 to 65535) of std_logic_vector(7 downto 0);
	signal data_mem: data := (others => (others => '0'));
	
	signal sig_datao: std_logic_vector(31 downto 0) := (others => '0');
	
	file file_RESULTS : text;
	signal data_out: std_logic_vector(31 downto 0);
	
begin
	process is
	begin
		wait until rising_edge (clk);
		sig_datao <= (others => '0');
		wait for 0.1 ns;
		if (memRead = '1' and to_integer(unsigned(endr)) < 65536) then
			wait for 4.9 ns;
			sig_datao <= data_mem(to_integer(unsigned(endr))) & data_mem(to_integer(unsigned(endr)+1)) & 
					data_mem(to_integer(unsigned(endr)+2)) & data_mem(to_integer(unsigned(endr)+3));
		elsif (memWrite = '1' and to_integer(unsigned(endw)) < 65536) then
			wait for 4.9 ns;
			data_mem(to_integer(unsigned(endw))) <= dataw(31 downto 24);
			data_mem(to_integer(unsigned(endw)+1)) <= dataw(23 downto 16);
			data_mem(to_integer(unsigned(endw)+2)) <= dataw(15 downto 8);
			data_mem(to_integer(unsigned(endw)+3)) <= dataw(7 downto 0);
		end if;
	end process;
	
	datao <= sig_datao;
	
	
	
	
	process is
	    variable v_OLINE     : line;
	    --variable v_ADD_TERM1 : std_logic_vector(c_WIDTH-1 downto 0);
	    --variable v_ADD_TERM2 : std_logic_vector(c_WIDTH-1 downto 0);
	    --variable v_SPACE     : character;
	     
	  begin
		  
		wait for 50 ns;
	 
	    file_open(file_RESULTS, "output_results.txt", write_mode);
	 
	    write(v_OLINE, data_out, right, 4);
	    writeline(file_RESULTS, v_OLINE);
		
		--assert false report "ESCRITA EM ARQUIVO";
	 
	    file_close(file_RESULTS);
	     
	end process;
	
	--data_out <= data_mem(0) & data_mem(1) & data_mem(2) & data_mem(3);
	--data_out <= data_mem(16) & data_mem(17) & data_mem(18) & data_mem(19);
	data_out <= data_mem(32) & data_mem(33) & data_mem(34) & data_mem(35);
	
	
	
	
	

end arch_cache_dados;