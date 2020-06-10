library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity femto_MIPS is
end femto_MIPS;

architecture arch_femto_MIPS of femto_MIPS is

	component clock_10ns is
		port( clk: out std_logic);
	end component;

	component instruction_fetch is
		port( clkIF_ID, clkCInst, clkPC, selPC: in std_logic;
			npcj: in std_logic_vector(31 downto 0);
			IF_IDout: out std_logic_vector(63 downto 0));
	end component;
	
	component instruction_decode is
		port( RIout: in std_logic_vector(63 downto 0);
			dataw: in std_logic_vector(31 downto 0);
			enderw: in std_logic_vector(4 downto 0);
			rw, clkID_EX: in std_logic;
			
			cWBo: out std_logic_vector(1 downto 0);	 
			cMDo: out std_logic_vector(2 downto 0);
			cEXo: out std_logic_vector(3 downto 0);
			ID_EXout: out std_logic_vector(137 downto 0));
	end component;
	
	component instruction_execution is
		port( ID_EXout: in std_logic_vector(137 downto 0);
			cWBo: in std_logic_vector(1 downto 0);
			cMDo: in std_logic_vector(2 downto 0);
			cEXo: in std_logic_vector(3 downto 0);
			clkEX_MD: in std_logic;
			
			cWBo1: out std_logic_vector(1 downto 0);
			cMDo1: out std_logic_vector(2 downto 0);
			zero: out std_logic;
			
			EX_MDout: out std_logic_vector(100 downto 0));
	end component;
	
	component memoria_dado is
		port( EX_MDo: in std_logic_vector(100 downto 0);
			cWBo: in std_logic_vector(1 downto 0);
			cMDo: in std_logic_vector(2 downto 0);
			zero, clkMD_WB: in std_logic;
			
			npcj: out std_logic_vector(31 downto 0);
			pcsrc: out std_logic;
			cWBo1: out std_logic_vector(1 downto 0);
			
			MD_WBo: out std_logic_vector(68 downto 0));
	end component;
	
	component write_back is
		port( MD_WBo: in std_logic_vector(68 downto 0);
			cWBo: in std_logic_vector(1 downto 0);
			
			regWrite: out std_logic;
			enderw: out std_logic_vector(4 downto 0);
			dataw: out std_logic_vector(31 downto 0));
	end component;
	
	signal sig_clk: std_logic;
	
	signal sigIF_IF_IDout: std_logic_vector(63 downto 0);
	
	signal sigID_cWBo: std_logic_vector(1 downto 0);
	signal sigID_cMDo: std_logic_vector(2 downto 0);
	signal sigID_cEXo: std_logic_vector(3 downto 0);
	signal sigID_ID_EXout: std_logic_vector(137 downto 0);
	
	signal sigEX_cWBo1: std_logic_vector(1 downto 0);
	signal sigEX_cMDo1: std_logic_vector(2 downto 0);
	signal sigEX_zero: std_logic;
	signal sigEX_EX_MDout: std_logic_vector(100 downto 0);
	
	signal sigMD_npcj: std_logic_vector(31 downto 0);
	signal sigMD_pcsrc: std_logic;
	signal sigMD_cWBo1: std_logic_vector(1 downto 0);
	signal sigMD_MD_WBo: std_logic_vector(68 downto 0);
	
	signal sigWB_regWrite: std_logic;
	signal sigWB_enderw: std_logic_vector(4 downto 0);
	signal sigWB_dataw: std_logic_vector(31 downto 0);

begin
	CLK_10: clock_10ns port map (sig_clk);
	I_F: instruction_fetch port map (sig_clk, sig_clk, sig_clk, sigMD_pcsrc, sigMD_npcj, sigIF_IF_IDout);
	I_D: instruction_decode port map (sigIF_IF_IDout, sigWB_dataw, sigWB_enderw, sigWB_regWrite, sig_clk, 
			sigID_cWBo, sigID_cMDo, sigID_cEXo, sigID_ID_EXout);
	E_X: instruction_execution port map (sigID_ID_EXout, sigID_cWBo, sigID_cMDo, sigID_cEXo, sig_clk, 
			sigEX_cWBo1, sigEX_cMDo1, sigEX_zero, sigEX_EX_MDout);
	M_D: memoria_dado port map (sigEX_EX_MDout, sigEX_cWBo1, sigEX_cMDo1, sigEX_zero, sig_clk, 
			sigMD_npcj, sigMD_pcsrc, sigMD_cWBo1, sigMD_MD_WBo);
	W_B: write_back port map (sigMD_MD_WBo, sigMD_cWBo1, sigWB_regWrite, sigWB_enderw, sigWB_dataw);

end arch_femto_MIPS;