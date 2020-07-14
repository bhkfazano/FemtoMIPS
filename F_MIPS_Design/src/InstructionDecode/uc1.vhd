library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity uc1 is
	port( finishIF_out, finishEX_out, finishMD_out, cont_en, pause_if, bubb_if, clk: in std_logic;
		cont_cycles_in: in std_logic_vector(31 downto 0);
		ci_cont_hits_in, ci_cont_misses_in, ci_cont_memaccess_in: in std_logic_vector(31 downto 0);
		cd_cont_hits_in, cd_cont_misses_in, cd_cont_memaccess_in: in std_logic_vector(31 downto 0);
		func: in std_logic_vector(5 downto 0);
		contin: in std_logic_vector(5 downto 0);
		cWB: out std_logic_vector(1 downto 0);
		cMD: out std_logic_vector(2 downto 0);
		cEX: out std_logic_vector(9 downto 0));
end uc1;

architecture arch_uc1 of uc1 is

	signal sig_cont_add, sig_cont_slt, sig_cont_jr, sig_cont_addu, sig_cont_sll, sig_cont_mul, 
		sig_cont_lw, sig_cont_sw, sig_cont_addi, sig_cont_beq, sig_cont_slti, sig_cont_bne, 
		sig_cont_j, sig_cont_jal: std_logic_vector(31 downto 0) := (others => '0');
	
	signal sig_last, sig_before_last: std_logic_vector(13 downto 0) := (others => '0');
	
	signal cont_cycles, ci_cont_hits, ci_cont_misses, ci_cont_memaccess: std_logic_vector(31 downto 0);
	signal cd_cont_hits, cd_cont_misses, cd_cont_memaccess: std_logic_vector(31 downto 0);

begin
	process is
	begin
		wait until rising_edge(finishIF_out);
		ci_cont_hits <= ci_cont_hits_in;
		ci_cont_misses <= ci_cont_misses_in;
		ci_cont_memaccess <= ci_cont_memaccess_in;
	end process;
	
	process is
	begin
		wait until rising_edge(finishEX_out);
		cd_cont_hits <= cd_cont_hits_in;
		cd_cont_misses <= cd_cont_misses_in;
		cd_cont_memaccess <= cd_cont_memaccess_in;
	end process;
	
	process is
	begin
		wait until rising_edge(finishMD_out);
		wait for 0.1 ns;
		cont_cycles <= cont_cycles_in;
	end process;
	
	process is
	begin
		if finishIF_out = '0' then
			if bubb_if = '1' then
				case sig_last is
					when "10000000000000" => 
						sig_cont_add <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_add)) - 1, 32));
					when "01000000000000" => 
						sig_cont_slt <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slt)) - 1, 32));
					when "00100000000000" => 
						sig_cont_jr <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jr)) - 1, 32));
					when "00010000000000" => 
						sig_cont_addu <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addu)) - 1, 32));
					when "00001000000000" => 
						sig_cont_sll <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sll)) - 1, 32));
					when "00000100000000" => 
						sig_cont_mul <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_mul)) - 1, 32));
					when "00000010000000" => 
						sig_cont_lw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_lw)) - 1, 32));
					when "00000001000000" => 
						sig_cont_sw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sw)) - 1, 32));
					when "00000000100000" => 
						sig_cont_addi <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addi)) - 1, 32));
					when "00000000010000" => 
						sig_cont_beq <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_beq)) - 1, 32));
					when "00000000001000" => 
						sig_cont_slti <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slti)) - 1, 32));
					when "00000000000100" => 
						sig_cont_bne <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_bne)) - 1, 32));
					when "00000000000010" => 
						sig_cont_j <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_j)) - 1, 32));
					when "00000000000001" => 
						sig_cont_jal <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jal)) - 1, 32));
					when others => null;
				end case;
				
				case sig_before_last is
					when "10000000000000" => 
						sig_cont_add <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_add)) - 1, 32));
					when "01000000000000" => 
						sig_cont_slt <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slt)) - 1, 32));
					when "00100000000000" => 
						sig_cont_jr <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jr)) - 1, 32));
					when "00010000000000" => 
						sig_cont_addu <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addu)) - 1, 32));
					when "00001000000000" => 
						sig_cont_sll <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sll)) - 1, 32));
					when "00000100000000" => 
						sig_cont_mul <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_mul)) - 1, 32));
					when "00000010000000" => 
						sig_cont_lw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_lw)) - 1, 32));
					when "00000001000000" => 
						sig_cont_sw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sw)) - 1, 32));
					when "00000000100000" => 
						sig_cont_addi <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addi)) - 1, 32));
					when "00000000010000" => 
						sig_cont_beq <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_beq)) - 1, 32));
					when "00000000001000" => 
						sig_cont_slti <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slti)) - 1, 32));
					when "00000000000100" => 
						sig_cont_bne <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_bne)) - 1, 32));
					when "00000000000010" => 
						sig_cont_j <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_j)) - 1, 32));
					when "00000000000001" => 
						sig_cont_jal <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jal)) - 1, 32));
					when others => null;
				end case;
			elsif bubb_if = '0' and pause_if = '0' and cont_en = '1' then
				sig_before_last <= sig_last;
				if (contin = "000000" and func = "100000") then
					sig_cont_add <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_add)) + 1, 32));
					sig_last <= "10000000000000";
				elsif (contin = "000000" and func = "101010") then
					sig_cont_slt <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slt)) + 1, 32));
					sig_last <= "01000000000000";
				elsif (contin = "000000" and func = "001000") then
					sig_cont_jr <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jr)) + 1, 32));
					sig_last <= "00100000000000";
				elsif (contin = "000000" and func = "100001") then
					sig_cont_addu <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addu)) + 1, 32));
					sig_last <= "00010000000000";
				elsif (contin = "000000" and func = "000000") then
					sig_cont_sll <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sll)) + 1, 32));
					sig_last <= "00001000000000";
				elsif (contin = "011100" and func = "000010") then
					sig_cont_mul <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_mul)) + 1, 32));
					sig_last <= "00000100000000";
				elsif contin = "100011" then
					sig_cont_lw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_lw)) + 1, 32));
					sig_last <= "00000010000000";
				elsif contin = "101011" then
					sig_cont_sw <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_sw)) + 1, 32));
					sig_last <= "00000001000000";
				elsif contin = "001000" then
					sig_cont_addi <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_addi)) + 1, 32));
					sig_last <= "00000000100000";
				elsif contin = "000100" then
					sig_cont_beq <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_beq)) + 1, 32));
					sig_last <= "00000000010000";
				elsif contin = "001010" then
					sig_cont_slti <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_slti)) + 1, 32));
					sig_last <= "00000000001000";
				elsif contin = "000101" then
					sig_cont_bne <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_bne)) + 1, 32));
					sig_last <= "00000000000100";
				elsif contin = "000010" then
					sig_cont_j <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_j)) + 1, 32));
					sig_last <= "00000000000010";
				elsif contin = "000011" then
					sig_cont_jal <= std_logic_vector(to_unsigned(to_integer(unsigned(sig_cont_jal)) + 1, 32));
					sig_last <= "00000000000001";
				else
					sig_last <= "00000000000000";
				end if;
			end if;
		end if;
		wait until rising_edge(clk);
	end process;
	
	cWB <= "01" when (contin = "000000" and func = "001000") or contin = "101011" or contin = "000100" or 
			contin = "000101" or contin = "000010" else
			
			"10" when contin = "100011" else
			
			"11" when (contin = "000000" and func = "100000") or (contin = "000000" and func = "101010") or 
			(contin = "000000" and func = "100001") or (contin = "000000" and func = "000000") or 
			(contin = "011100" and func = "000010") or contin = "001000" or contin = "001010" or 
			contin = "000011" else "ZZ";
	
	cMD <= "000" when (contin = "000000" and func = "100000") or (contin = "000000" and func = "101010") or 
			(contin = "000000" and func = "100001") or (contin = "000000" and func = "000000") or 
			(contin = "011100" and func = "000010") or contin = "001000" or contin = "001010" else
			
			"001" when (contin = "000000" and func = "001000") or contin = "000100" or contin = "000101" or 
			contin = "000010" or contin = "000011" else
			
			"010" when contin = "100011" else
			
			"100" when contin = "101011" else "ZZZ";
	
	cEX <= "0000000011" when (contin = "000000" and func = "100000") else
		
			"0000100011" when (contin = "000000" and func = "101010") else
			
			"0011110000" when (contin = "000000" and func = "001000") else
			
			"0000010011" when (contin = "000000" and func = "100001") else
			
			"1000110011" when (contin = "000000" and func = "000000") else
			
			"0001100011" when (contin = "011100" and func = "000010") else
			
			"0000001000" when contin = "100011" or contin = "101011" else
			
			"0000001010" when contin = "001000" else
			
			"0001000000" when contin = "000100" else
			
			"0000101010" when contin = "001010" else
			
			"0001010000" when contin = "000101" else
			
			"0101111000" when contin = "000010" else
			
			"0101111100" when contin = "000011" else "ZZZZZZZZZZ";
	
	process is
		variable v_OLINE: line;
		file file_RESULTS: text;
	     
	  begin
		  
		wait until rising_edge(finishMD_out);
		wait for 1 ns;
	 
	    file_open(file_RESULTS, "stats.txt", write_mode);
	 
	    write(v_OLINE, "Número de ciclos: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(cont_cycles)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Tempo de execução (ns): ", right, 1);
	    write(v_OLINE, 10 * to_integer(unsigned(cont_cycles)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, " ", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, "CACHE DE INSTRUÇÕES", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de hits: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(ci_cont_hits)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de misses: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(ci_cont_misses)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Hit ratio (%): ", right, 1);
	    write(v_OLINE, 100 * to_integer(unsigned(ci_cont_hits)) / (to_integer(unsigned(ci_cont_hits)) + 
				to_integer(unsigned(ci_cont_misses))), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de acessos à memória: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(ci_cont_memaccess)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, " ", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, "CACHE DE DADOS", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de hits: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(cd_cont_hits)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de misses: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(cd_cont_misses)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Hit ratio (%): ", right, 1);
	    write(v_OLINE, 100 * to_integer(unsigned(cd_cont_hits)) / (to_integer(unsigned(cd_cont_hits)) + 
				to_integer(unsigned(cd_cont_misses))), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de acessos à memória: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(cd_cont_memaccess)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, " ", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, "INSTRUÇÕES", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número total de instruções: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_add)) + to_integer(unsigned(sig_cont_slt)) + 
				to_integer(unsigned(sig_cont_jr)) + to_integer(unsigned(sig_cont_addu)) + 
				to_integer(unsigned(sig_cont_sll)) + to_integer(unsigned(sig_cont_mul)) + 
				to_integer(unsigned(sig_cont_lw)) + to_integer(unsigned(sig_cont_sw)) + 
				to_integer(unsigned(sig_cont_addi)) + to_integer(unsigned(sig_cont_beq)) + 
				to_integer(unsigned(sig_cont_slti)) + to_integer(unsigned(sig_cont_bne)) + 
				to_integer(unsigned(sig_cont_j)) + to_integer(unsigned(sig_cont_jal)), right, 1);
		writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "Número de instruções ADD: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_add)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     SLT: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_slt)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     JR: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_jr)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     ADDU: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_addu)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     SLL: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_sll)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     MUL: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_mul)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     LW: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_lw)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     SW: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_sw)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     ADDI: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_addi)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     BEQ: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_beq)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     SLTI: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_slti)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     BNE: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_bne)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     J: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_j)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		write(v_OLINE, "                     JAL: ", right, 1);
	    write(v_OLINE, to_integer(unsigned(sig_cont_jal)), right, 1);
	    writeline(file_RESULTS, v_OLINE);
	    write(v_OLINE, " ", right, 1);
	    writeline(file_RESULTS, v_OLINE);
		
		write(v_OLINE, "100*CPI: ", right, 1);
	    write(v_OLINE, 100 * to_integer(unsigned(cont_cycles)) / 
				(to_integer(unsigned(sig_cont_add)) + to_integer(unsigned(sig_cont_slt)) + 
				to_integer(unsigned(sig_cont_jr)) + to_integer(unsigned(sig_cont_addu)) + 
				to_integer(unsigned(sig_cont_sll)) + to_integer(unsigned(sig_cont_mul)) + 
				to_integer(unsigned(sig_cont_lw)) + to_integer(unsigned(sig_cont_sw)) + 
				to_integer(unsigned(sig_cont_addi)) + to_integer(unsigned(sig_cont_beq)) + 
				to_integer(unsigned(sig_cont_slti)) + to_integer(unsigned(sig_cont_bne)) + 
				to_integer(unsigned(sig_cont_j)) + to_integer(unsigned(sig_cont_jal))), right, 1);
	    writeline(file_RESULTS, v_OLINE);
		
		file_close(file_RESULTS);
	end process;

end arch_uc1;