library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
	port( A, B: in std_logic_vector(31 downto 0);
			ctl: in std_logic_vector(2 downto 0);
			C: out std_logic_vector(31 downto 0);
			zero: out std_logic);
end ula;

architecture arch_ula of ula is
	signal sig_set_on_less_than: std_logic;
	signal sig_xor, sig_diff: std_logic_vector(31 downto 0);
	
	signal sig_C: std_logic_vector(31 downto 0);
	signal const_zero: std_logic_vector(31 downto 0) := (others => '0');
	
begin
	sig_set_on_less_than <= '1' when signed(A) < signed(B) else '0';
	sig_xor <= A xor B;
	sig_diff <= const_zero when sig_xor /= const_zero else (others => '1');
	
	with ctl select
		sig_C <= std_logic_vector(signed(A) + signed(B)) when "000",
			std_logic_vector(unsigned(A) + unsigned(B)) when "001",
			const_zero(30 downto 0) & sig_set_on_less_than when "010",
			A(31-to_integer(unsigned(B(10 downto 6))) downto 0) & 
					const_zero(to_integer(unsigned(B(10 downto 6)))-1 downto 0) when "011",
			sig_xor when "100",
			sig_diff when "101",
			(others => '0') when others;
	
	C <= sig_C;
	
	zero <= '1' when sig_C = const_zero else '0';
	
end arch_ula;