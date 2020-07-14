library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ex_md is
	port( finish_in, pause, bubb: in std_logic;
		cWBo: in std_logic_vector(1 downto 0);
		cMDo: in std_logic_vector(2 downto 0);
		npcj: in std_logic_vector(31 downto 0);
		zero: in std_logic;
		ulao, reg: in std_logic_vector(31 downto 0);
		endreg: in std_logic_vector(4 downto 0);
		clkEX_MD: in std_logic;
		
		cWBo1: out std_logic_vector(1 downto 0);
		cMDo1: out std_logic_vector(2 downto 0);
		zeroo: out std_logic;
		EX_MDo: out std_logic_vector(100 downto 0);
		finish_out: out std_logic);
end ex_md;

architecture arch_ex_md of ex_md is

	signal sig_cWBo1: std_logic_vector(1 downto 0) := "00";	 
	signal sig_cMDo1: std_logic_vector(2 downto 0) := "000";
	signal sig_zeroo: std_logic := '0';
	signal sig_EX_MDo: std_logic_vector(100 downto 0) := (others => '0');
	signal sig_finish_out: std_logic := '0';

begin
	process is
	begin
		wait until rising_edge (clkEX_MD);
		if pause = '0' then
			if bubb = '1' then
				sig_cWBo1 <= "00";
				sig_cMDo1 <= "000";
				sig_zeroo <= '1';
				sig_EX_MDo <= (others => '0');
				sig_finish_out <= sig_finish_out;
			else
				sig_cWBo1 <= cWBo;
				sig_cMDo1 <= cMDo;
				sig_zeroo <= zero;
				sig_EX_MDo <= endreg & reg & ulao & npcj;
				sig_finish_out <= finish_in;
			end if;
		end if;
	end process;
	
	cWBo1 <= sig_cWBo1;
	cMDo1 <= sig_cMDo1;
	zeroo <= sig_zeroo;
	EX_MDo <= sig_EX_MDo;
	finish_out <= sig_finish_out;
	
end arch_ex_md;