library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity md_wb is
	port( pause, bubb: in std_logic;
		cWBo: in std_logic_vector(1 downto 0);
		dmout, regout: in std_logic_vector(31 downto 0);
		endw: in std_logic_vector(4 downto 0);
		clkMD_WB: in std_logic;
		
		cWBo1: out std_logic_vector(1 downto 0);
		MD_WBo: out std_logic_vector(68 downto 0));
end md_wb;

architecture arch_md_wb of md_wb is

	signal sig_cWBo1: std_logic_vector(1 downto 0) := "00";
	signal sig_MD_WBo: std_logic_vector(68 downto 0) := (others => '0');

begin
	process is
	begin
		wait until rising_edge (clkMD_WB) and pause = '0';
		if bubb = '1' then
			sig_cWBo1 <= "00";
			sig_MD_WBo <= (others => '0');
		else
			sig_cWBo1 <= cWBo;
			sig_MD_WBo <= endw & regout & dmout;
		end if;
	end process;
	
	cWBo1 <= sig_cWBo1;
	MD_WBo <= sig_MD_WBo;
	
end arch_md_wb;