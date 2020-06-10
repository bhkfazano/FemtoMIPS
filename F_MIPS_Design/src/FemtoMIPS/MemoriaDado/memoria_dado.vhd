library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_dado is
	port( EX_MDo: in std_logic_vector(100 downto 0);
		cWBo: in std_logic_vector(1 downto 0);
		cMDo: in std_logic_vector(2 downto 0);
		zero, clkMD_WB: in std_logic;
		
		npcj: out std_logic_vector(31 downto 0);
		pcsrc: out std_logic;
		cWBo1: out std_logic_vector(1 downto 0);
		
		MD_WBo: out std_logic_vector(68 downto 0));
end memoria_dado;

architecture arch_memoria_dado of memoria_dado is

	component and2 is
		port( in1, in2: in std_logic;
			out1: out std_logic);
	end component;
	
	component cache_dados is
		port( endr, endw, dataw: in std_logic_vector(31 downto 0);
			memRead, memWrite: in std_logic;		
			datao: out std_logic_vector(31 downto 0));
	end component;
	
	component md_wb is
		port( cWBo: in std_logic_vector(1 downto 0);
			dmout, regout: in std_logic_vector(31 downto 0);
			endw: in std_logic_vector(4 downto 0);
			clkMD_WB: in std_logic;
			
			cWBo1: out std_logic_vector(1 downto 0);
			MD_WBo: out std_logic_vector(68 downto 0));
	end component;
	
	signal sig_dmout: std_logic_vector(31 downto 0);
	
begin
	AND_2: and2 port map (cMDo(0), zero, pcsrc);
	CACHED: cache_dados port map (EX_MDo(63 downto 32), EX_MDo(63 downto 32), EX_MDo(95 downto 64), cMDo(1), 
			cMDo(2), sig_dmout);
	MDWB: md_wb port map (cWBo, sig_dmout, EX_MDo(95 downto 64), EX_MDo(100 downto 96), clkMD_WB, cWBo1, MD_WBo);
	
	npcj <= EX_MDo(31 downto 0);
	
end arch_memoria_dado;