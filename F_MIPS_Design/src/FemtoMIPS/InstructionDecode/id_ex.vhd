library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_ex is
	port( pause, bubb: in std_logic;
		cWB: in std_logic_vector(1 downto 0);	 
		cMD: in std_logic_vector(2 downto 0);
		cEX: in std_logic_vector(8 downto 0);	
		
		cWBo: out std_logic_vector(1 downto 0);	 
		cMDo: out std_logic_vector(2 downto 0);
		cEXo: out std_logic_vector(8 downto 0);
		
		npc, rega, regb, sext: in std_logic_vector(31 downto 0);
		rt, rd: in std_logic_vector(4 downto 0);
		clkID_EX: in std_logic;					
		
		ID_EXout: out std_logic_vector(137 downto 0));
end id_ex;

architecture arch_id_ex of id_ex is

	signal sig_cWBo: std_logic_vector(1 downto 0) := "00";	 
	signal sig_cMDo: std_logic_vector(2 downto 0) := "000";
	signal sig_cEXo: std_logic_vector(8 downto 0) := "000111010";
	signal sig_ID_EXout: std_logic_vector(137 downto 0) := (others => '0');

begin
	process is
	begin
		wait until rising_edge (clkID_EX) and pause = '0';
		if bubb = '1' then
			sig_cWBo <= "00";
			sig_cMDo <= "000";
			sig_cEXo <= "000111010";
			sig_ID_EXout <= (others => '0');
		else
			sig_cWBo <= cWB;
			sig_cMDo <= cMD;
			sig_cEXo <= cEX;
			sig_ID_EXout <= npc & rega & regb & sext & rt & rd;
		end if;
	end process;
	
	cWBo <= sig_cWBo;
	cMDo <= sig_cMDo;
	cEXo <= sig_cEXo;
	ID_EXout <= sig_ID_EXout;
	
end arch_id_ex;