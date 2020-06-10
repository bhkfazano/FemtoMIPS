library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decode is
	port( RIout: in std_logic_vector(63 downto 0);
		dataw: in std_logic_vector(31 downto 0);
		enderw: in std_logic_vector(4 downto 0);
		rw, clkID_EX: in std_logic;
		
		cWBo: out std_logic_vector(1 downto 0);	 
		cMDo: out std_logic_vector(2 downto 0);
		cEXo: out std_logic_vector(3 downto 0);
		ID_EXout: out std_logic_vector(137 downto 0));
end instruction_decode;

architecture arch_instruction_decode of instruction_decode is

	component mem_register is
		port( endA, endB, endW: in std_logic_vector(4 downto 0);
			dataW: in std_logic_vector(31 downto 0);
			regWrite: in std_logic;
			dataA, dataB: out std_logic_vector(31 downto 0));
	end component;
	
	component sign_extend is
		port( in1: in std_logic_vector(15 downto 0);
			out1: out std_logic_vector(31 downto 0));
	end component; 
	
	component uc1 is
		port( contin: in std_logic_vector(5 downto 0);
			cWB: out std_logic_vector(1 downto 0);	 
			cMD: out std_logic_vector(2 downto 0);
			cEX: out std_logic_vector(3 downto 0));
	end component;
	
	component id_ex is
		port( cWB: in std_logic_vector(1 downto 0);	 
			cMD: in std_logic_vector(2 downto 0);
			cEX: in std_logic_vector(3 downto 0);	
			
			cWBo: out std_logic_vector(1 downto 0);	 
			cMDo: out std_logic_vector(2 downto 0);
			cEXo: out std_logic_vector(3 downto 0);
			
			npc, rega, regb, sext: in std_logic_vector(31 downto 0);
			rt, rd: in std_logic_vector(4 downto 0);
			clkID_EX: in std_logic;					
			
			ID_EXout: out std_logic_vector(137 downto 0));
	end component;
	
	signal sig_cWB: std_logic_vector(1 downto 0);
	signal sig_cMD: std_logic_vector(2 downto 0);
	signal sig_cEX: std_logic_vector(3 downto 0);
	signal sig_rega, sig_regb, sig_sext: std_logic_vector(31 downto 0);
	
begin
	MEM_REG: mem_register port map (RIout(57 downto 53), RIout(52 downto 48), enderw, dataw, rw,
		sig_rega, sig_regb);
	SIGN_EXT: sign_extend port map (RIout(47 downto 32), sig_sext);
	UC_1: uc1 port map (RIout(63 downto 58), sig_cWB, sig_cMD, sig_cEX);
	ID_EXec: id_ex port map (sig_cWB, sig_cMD, sig_cEX, cWBo, cMDo, cEXo, RIout(31 downto 0), sig_rega, 
		sig_regb, sig_sext, RIout(52 downto 48), RIout(47 downto 43), clkID_EX, ID_EXout);
		
end arch_instruction_decode;