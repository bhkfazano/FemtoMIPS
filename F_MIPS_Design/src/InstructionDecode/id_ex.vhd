library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity id_ex is
	port( finish_in, pause, bubb: in std_logic;
		cWB: in std_logic_vector(1 downto 0);	 
		cMD: in std_logic_vector(2 downto 0);
		cEX: in std_logic_vector(9 downto 0);	
		
		cWBo: out std_logic_vector(1 downto 0);	 
		cMDo: out std_logic_vector(2 downto 0);
		cEXo: out std_logic_vector(9 downto 0);
		
		npc, rega, regb, sext: in std_logic_vector(31 downto 0);
		rt, rd: in std_logic_vector(4 downto 0);
		clkID_EX: in std_logic;
		jump_to_in: in std_logic_vector(31 downto 0);
		
		jump_to: out std_logic_vector(31 downto 0);
		ID_EXout: out std_logic_vector(137 downto 0);
		finish_out: out std_logic);
end id_ex;

architecture arch_id_ex of id_ex is

	signal sig_cWBo: std_logic_vector(1 downto 0) := "00";	 
	signal sig_cMDo: std_logic_vector(2 downto 0) := "000";
	signal sig_cEXo: std_logic_vector(9 downto 0) := "1000110011";
	signal sig_jump_to: std_logic_vector(31 downto 0) := (others => '0');
	signal sig_ID_EXout: std_logic_vector(137 downto 0) := (others => '0');
	signal sig_finish_out: std_logic := '0';

begin
	process is
	begin
		wait until rising_edge (clkID_EX);
		if pause = '0' then
			if bubb = '1' then
				sig_cWBo <= "00";
				sig_cMDo <= "000";
				sig_cEXo <= "1000110011";
				sig_jump_to <= (others => '0');
				sig_ID_EXout <= (others => '0');
				sig_finish_out <= sig_finish_out;
			else
				sig_cWBo <= cWB;
				sig_cMDo <= cMD;
				sig_cEXo <= cEX;
				sig_jump_to <= jump_to_in;
				sig_ID_EXout <= npc & rega & regb & sext & rt & rd;
				sig_finish_out <= finish_in;
			end if;
		end if;
	end process;
	
	cWBo <= sig_cWBo;
	cMDo <= sig_cMDo;
	cEXo <= sig_cEXo;
	jump_to <= sig_jump_to;
	ID_EXout <= sig_ID_EXout;
	finish_out <= sig_finish_out;
	
end arch_id_ex;