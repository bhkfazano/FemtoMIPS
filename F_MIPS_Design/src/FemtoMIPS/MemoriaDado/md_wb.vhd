library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity md_wb is
	port( cWBo: in std_logic_vector(1 downto 0);
		dmout, regout: in std_logic_vector(31 downto 0);
		endw: in std_logic_vector(4 downto 0);
		clkMD_WB: in std_logic;
		
		cWBo1: out std_logic_vector(1 downto 0);
		MD_WBo: out std_logic_vector(68 downto 0));
end md_wb;

architecture arch_md_wb of md_wb is

	signal sig_cWBo1: std_logic_vector(1 downto 0);	 
	signal sig_MD_WBo: std_logic_vector(68 downto 0);

begin
	process is
	begin
		wait until rising_edge (clkMD_WB);
		sig_cWBo1 <= cWBo;
		sig_MD_WBo <= endw & regout & dmout;
	end process;
	
	cWBo1 <= sig_cWBo1;
	MD_WBo <= sig_MD_WBo;
	
end arch_md_wb;