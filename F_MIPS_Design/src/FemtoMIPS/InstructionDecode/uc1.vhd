library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc1 is
	port( func: in std_logic_vector(5 downto 0);
		contin: in std_logic_vector(5 downto 0);
		signext_enable: out std_logic;
		cWB: out std_logic_vector(1 downto 0);	 
		cMD: out std_logic_vector(2 downto 0);
		cEX: out std_logic_vector(8 downto 0));
end uc1;

architecture arch_uc1 of uc1 is
begin
	signext_enable <= '0' when contin = "000010" or contin = "000011" else '1';
	
	cWB <= "01" when (contin = "000000" and func = "001000") or contin = "101011" or contin = "000100" or 
			contin = "000101" or contin = "000010" else
			
			"10" when contin = "100011" else
			
			"11" when (contin = "000000" and func = "100000") or (contin = "000000" and func = "101010") or 
			(contin = "000000" and func = "100001") or (contin = "000000" and func = "000000") or 
			contin = "001000" or contin = "001010" or contin = "000011" else "ZZ";
	
	cMD <= "000" when (contin = "000000" and func = "100000") or (contin = "000000" and func = "101010") or 
			(contin = "000000" and func = "100001") or (contin = "000000" and func = "000000") or 
			contin = "001000" or contin = "001010" else
			
			"001" when (contin = "000000" and func = "001000") or contin = "000100" or contin = "000101" or 
			contin = "000010" or contin = "000011" else
			
			"010" when contin = "100011" else
			
			"100" when contin = "101011" else "ZZZ";
	
	cEX <= "000000011" when (contin = "000000" and func = "100000") else
		
			"000100011" when (contin = "000000" and func = "101010") else
			
			"011110000" when (contin = "000000" and func = "001000") else
			
			"000010011" when (contin = "000000" and func = "100001") else
			
			"000111010" when (contin = "000000" and func = "000000") else
			
			"000001000" when contin = "100011" or contin = "101011" else
			
			"000001010" when contin = "001000" else
			
			"001000000" when contin = "000100" else
			
			"000101010" when contin = "001010" else
			
			"001010000" when contin = "000101" else
			
			"101111000" when contin = "000010" else
			
			"101111100" when contin = "000011" else "ZZZZZZZZZ";
	
end arch_uc1;