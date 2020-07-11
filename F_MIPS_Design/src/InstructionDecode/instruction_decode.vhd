library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_decode is
	port( pause, bubb: in std_logic;
		RIout: in std_logic_vector(63 downto 0);
		dataw: in std_logic_vector(31 downto 0);
		enderw: in std_logic_vector(4 downto 0);
		rw, clkID_EX: in std_logic;
		
		cWBo: out std_logic_vector(1 downto 0);	 
		cMDo: out std_logic_vector(2 downto 0);
		cEXo: out std_logic_vector(9 downto 0);
		ID_EXout: out std_logic_vector(137 downto 0);
		jump_to: out std_logic_vector(31 downto 0));
end instruction_decode;

architecture arch_instruction_decode of instruction_decode is

	component mem_register is
		port( clk: in std_logic;
			endA, endB, endW: in std_logic_vector(4 downto 0);
			dataW: in std_logic_vector(31 downto 0);
			regWrite: in std_logic;
			dataA, dataB: out std_logic_vector(31 downto 0));
	end component;
	
	component sign_extend is
		port( in1: in std_logic_vector(15 downto 0);
			out1: out std_logic_vector(31 downto 0));
	end component; 
	
	component uc1 is
		port( func: in std_logic_vector(5 downto 0);
			contin: in std_logic_vector(5 downto 0);
			cWB: out std_logic_vector(1 downto 0);	 
			cMD: out std_logic_vector(2 downto 0);
			cEX: out std_logic_vector(9 downto 0));
	end component;
	
	component id_ex is
		port( pause, bubb: in std_logic;
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
			ID_EXout: out std_logic_vector(137 downto 0));
	end component;
	
	signal sig_cWB: std_logic_vector(1 downto 0);
	signal sig_cMD: std_logic_vector(2 downto 0);
	signal sig_cEX: std_logic_vector(9 downto 0);
	signal sig_rega, sig_regb, sig_sext, sig_jump_to: std_logic_vector(31 downto 0);
	
begin
	MEM_REG: mem_register port map (clkID_EX, RIout(57 downto 53), RIout(52 downto 48), enderw, dataw, rw,
		sig_rega, sig_regb);
	SIGN_EXT: sign_extend port map (RIout(47 downto 32), sig_sext);
	UC_1: uc1 port map (RIout(37 downto 32), RIout(63 downto 58), sig_cWB, sig_cMD, sig_cEX);
	ID_EXec: id_ex port map (pause, bubb, sig_cWB, sig_cMD, sig_cEX, cWBo, cMDo, cEXo, RIout(31 downto 0), sig_rega, 
		sig_regb, sig_sext, RIout(52 downto 48), RIout(47 downto 43), clkID_EX, sig_jump_to, jump_to, ID_EXout);
	
	sig_jump_to <= RIout(31 downto 28) & RIout(57 downto 32) & "00";
		
end arch_instruction_decode;