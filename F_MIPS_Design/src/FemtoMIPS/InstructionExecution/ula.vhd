library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port( A, B: in std_logic_vector(31 downto 0);		-- A e B: duas entradas de 32 bits
			ctl: in std_logic_vector(2 downto 0);		-- ctl: codigo de controle de operacao (3 bits)
			C: out std_logic_vector(31 downto 0);		-- C: saida de 32 bits
			zero: out std_logic);						-- zero: 1 bit, indica se o resultado em C foi zero
end ula;

architecture arch_ula of ula is
	signal sig_set_on_less_than: std_logic;			-- sinal auxiliar para a operacao set on less than
	signal sig_C: std_logic_vector(31 downto 0);	-- sinal auxiliar para C, pois nao se pode ler uma saida dentro
													-- da arquitetura (operacao necessaria para o valor da saida "zero")
begin
	sig_set_on_less_than <= '1' when unsigned(A) < unsigned(B) else '0'; -- indica se A < B, ambos unsigned
	
	with ctl select
		sig_C <= A and B when "000",					-- ctl 000 -> C recebe A and B (bit a bit)
	
			A or B when "001",							-- ctl 001 -> C recebe A or B (bit a bit)
		
			std_logic_vector(unsigned(A) + unsigned(B)) when "010", -- ctl 010 -> soma unsigned
			
			std_logic_vector(signed(A) + signed(B)) when "011",		 -- ctl 011 -> soma signed
			
			"0000000000000000000000000000000" & sig_set_on_less_than when "100",	-- ctl 100 -> set on less than:
																		-- recebe 00...01 quando B > A (ambos unsigned)
																		-- e 00...00 caso contrario
			
			std_logic_vector(unsigned(A) - unsigned(B)) when "101", -- ctl 101 -> subt. unsigned
			
			std_logic_vector(signed(A) - signed(B)) when "110",		 -- ctl 110 -> subt. signed
			
			(others => 'Z') when others;					-- ctl 111 -> NOP (no operation): alta impedancia (High Z)
	
	C <= sig_C;
	
	zero <= '1' when sig_C = "00000000000000000000000000000000" else '0';  -- saida zero ativa '1' indica resultado nulo
	
end arch_ula;