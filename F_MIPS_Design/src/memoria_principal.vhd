library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity memoria_principal is
	port( enable, write_en: in std_logic;
		dadosin, ender: in std_logic_vector(31 downto 0);
		pronto, write_atual: out std_logic;
		ender_atual: out std_logic_vector(31 downto 0);
		dados: out std_logic_vector(127 downto 0));
end memoria_principal;

architecture arch_memoria_principal of memoria_principal is
	type data is array(0 to 65535) of std_logic_vector(7 downto 0);
	signal data_mem: data := --(others => (others => '0'));
			(0 => "00100000") & (1 => "00000001") & (2 => "00000000") & (3 => "00001010") & --addi $0, $1, 10
			
			(4 => "00100000") & (5 => "01100010") & (6 => "00000000") & (7 => "00100000") & --addi $3, $2, 32
			
			--(8 => "00000000") & (9 => "01000000") & (10 => "00000000") & (11 => "00001000") & --jr $2
			--(8 => "00001100") & (9 => "00000000") & (10 => "00000000") & (11 => "00000110") & --jal 24
			--(8 => "00001000") & (9 => "00000000") & (10 => "00000000") & (11 => "00000110") & --j 24
			(8 => "00000000") & (9 => "00000000") & (10 => "00000000") & (11 => "00000000") & 
			
			(12 => "00000000") & (13 => "00000010") & (14 => "00001000") & (15 => "10000000") & --sll $2, $1, 2
			
			(16 => "00000000") & (17 => "00100010") & (18 => "00011000") & (19 => "00100001") & --addu $1, $2, $3
			
			(20 => "00101000") & (21 => "00100100") & (22 => "00000000") & (23 => "10000000") & --slti $1, $4, 128
			
			(24 => "00000000") & (25 => "10000001") & (26 => "00101000") & (27 => "00101010") & --slt $4, $1, $5
			
			(28 => "10101100") & (29 => "00000011") & (30 => "00000000") & (31 => "00010000") & --sw $3, 16($0)
			
			(32 => "10001100") & (33 => "00000110") & (34 => "00000000") & (35 => "00010000") & --lw $6, 16($0)
			
			(36 => "10101100") & (37 => "00000110") & (38 => "00000000") & (39 => "00000000") & --sw $6, 0($0)
			
			(40 => "10001100") & (41 => "00000111") & (42 => "00000000") & (43 => "00000000") & --lw $7, 0($0)
			
			--(44 => "00010100") & (45 => "11000111") & (46 => "00000000") & (47 => "00000001") & --bne $6, $7, 1
			--(44 => "00000000") & (45 => "00000000") & (46 => "00000000") & (47 => "00000000") & 
			--(44 => "00100000") & (45 => "11101000") & (46 => "00000000") & (47 => "10100111") & --addi $7, $8, 167
			(44 => "00100000") & (45 => "11101000") & (46 => "00000000") & (47 => "00000111") & --addi $7, $8, 7
			
			--"011100SSSSSTTTTTDDDDDXXXXX000010"
			(48 => "01110001") & (49 => "00000011") & (50 => "01001000") & (51 => "00000010") & --mul $8, $3, $9
			--(48 => "00100001") & (49 => "00001000") & (50 => "00000000") & (51 => "00000111") & --addi $8, $8, 7
			--(48 => "00100000") & (49 => "11101000") & (50 => "00000000") & (51 => "00000111") & --addi $7, $8, 7
			
			(52 => "10101100") & (53 => "00001001") & (54 => "00000000") & (55 => "00100000") & --sw $9, 32($0)
			
			(56 => "10101100") & (57 => "00001010") & (58 => "00000000") & (59 => "00100000") & --sw $10, 32($0)
			
			--(60 to 65535 => "00000000");
			
			(60 => "11111111") & (61 => "11111111") & (62 => "11111111") & (63 => "11111111") & --END
			
			(64 to 65535 => "00000000");
			
			
			
			--(0 => "00100000") & (1 => "00000001") & (2 => "00000000") & (3 => "00001010") & --addi $0, $1, 10
			
			--(4 => "10101100") & (5 => "00000001") & (6 => "00000000") & (7 => "00100000") & --sw $1, 32($0)
			
			--(8 => "10101100") & (9 => "00000001") & (10 => "00000000") & (11 => "00100000") & --sw $1, 32($0)
			
			--(12 to 65535 => "00000000");
			
			--(12 => "00000000") & (13 => "00000000") & (14 => "00000000") & (15 => "00000000") & 
			
			--(16 => "00000000") & (17 => "00000000") & (18 => "00000000") & (19 => "00000000") & 
			
			--(20 => "10101100") & (21 => "00000001") & (22 => "00000000") & (23 => "00100000") & --sw $1, 32($0)
			
			--(24 => "10101100") & (25 => "00000001") & (26 => "00000000") & (27 => "00100000") & --sw $1, 32($0)
			
			--(28 to 65535 => "00000000");
	
	signal last_write: std_logic := '1';
	signal last_ender: std_logic_vector(31 downto 0) := (others => '1');
	
	signal sig_pronto: std_logic := '0';
	signal sig_dados: std_logic_vector(127 downto 0);
	
	file file_RESULTS : text;
	signal data_out: std_logic_vector(31 downto 0);
	
begin
	process is
	begin
		if write_en = last_write and ender = last_ender then
			wait until not (write_en = last_write and ender = last_ender);
		end if;
		
		wait for 0.01 ns;
		sig_pronto <= '0';
		last_write <= write_en;
		last_ender <= ender;
		if (enable = '1' and to_integer(unsigned(last_ender)) < 65536) then
			wait for 39.99 ns;
			if (last_write = '0') then
				sig_dados <= data_mem(to_integer(unsigned(last_ender))) & data_mem(to_integer(unsigned(last_ender)+1)) & 
					data_mem(to_integer(unsigned(last_ender)+2)) & data_mem(to_integer(unsigned(last_ender)+3)) & 
					data_mem(to_integer(unsigned(last_ender)+4)) & data_mem(to_integer(unsigned(last_ender)+5)) & 
					data_mem(to_integer(unsigned(last_ender)+6)) & data_mem(to_integer(unsigned(last_ender)+7)) & 
					data_mem(to_integer(unsigned(last_ender)+8)) & data_mem(to_integer(unsigned(last_ender)+9)) & 
					data_mem(to_integer(unsigned(last_ender)+10)) & data_mem(to_integer(unsigned(last_ender)+11)) & 
					data_mem(to_integer(unsigned(last_ender)+12)) & data_mem(to_integer(unsigned(last_ender)+13)) & 
					data_mem(to_integer(unsigned(last_ender)+14)) & data_mem(to_integer(unsigned(last_ender)+15));
			else
				data_mem(to_integer(unsigned(last_ender))) <= dadosin(31 downto 24);
				data_mem(to_integer(unsigned(last_ender)+1)) <= dadosin(23 downto 16);
				data_mem(to_integer(unsigned(last_ender)+2)) <= dadosin(15 downto 8);
				data_mem(to_integer(unsigned(last_ender)+3)) <= dadosin(7 downto 0);
			end if;
			sig_pronto <= '1';
		end if;
	end process;
	
	write_atual <= last_write;
	ender_atual <= last_ender;
	pronto <= sig_pronto;
	dados <= sig_dados;
	
	
	
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

end arch_memoria_principal;