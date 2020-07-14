library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoria_dado is
	port( finish_in, write_atual, pause, bubb, pronto: in std_logic;
		ender_atual: in std_logic_vector(31 downto 0);
		EX_MDo: in std_logic_vector(100 downto 0);
		cWBo: in std_logic_vector(1 downto 0);
		cMDo: in std_logic_vector(2 downto 0);
		zero, clkMD_WB: in std_logic;
		dadosin: in std_logic_vector(127 downto 0);
		
		pause_pipe, miss, write_en: out std_logic;
		dadosout, enderout: out std_logic_vector(31 downto 0);
		npcj: out std_logic_vector(31 downto 0);
		pcsrc: out std_logic;
		cWBo1: out std_logic_vector(1 downto 0);
		
		MD_WBo: out std_logic_vector(68 downto 0);
		finish_out: out std_logic;
		cont_hits, cont_misses, cont_memaccess: out std_logic_vector(31 downto 0));
end memoria_dado;

architecture arch_memoria_dado of memoria_dado is

	component and2 is
		port( in1, in2: in std_logic;
			out1: out std_logic);
	end component;
	
	component cache_dados is
		port( clk, pronto, memRead, memWrite, write_atual: in std_logic;
			dadosin: in std_logic_vector(127 downto 0);
			ender_atual, endr, endw, dataw: in std_logic_vector(31 downto 0);
			pause_pipe, miss, write_en: out std_logic;
			dadosout, enderout, datao, cont_hits, cont_misses, cont_memaccess: out std_logic_vector(31 downto 0));
	end component;
	
	component md_wb is
		port( finish_in, pause, bubb: in std_logic;
			cWBo: in std_logic_vector(1 downto 0);
			dmout, regout: in std_logic_vector(31 downto 0);
			endw: in std_logic_vector(4 downto 0);
			clkMD_WB: in std_logic;
			
			cWBo1: out std_logic_vector(1 downto 0);
			MD_WBo: out std_logic_vector(68 downto 0);
			finish_out: out std_logic);
	end component;
	
	signal sig_dmout: std_logic_vector(31 downto 0);
	
begin
	AND_2: and2 port map (cMDo(0), zero, pcsrc);
	CACHED: cache_dados port map (clkMD_WB, pronto, cMDo(1), cMDo(2), write_atual, dadosin, ender_atual, 
			EX_MDo(63 downto 32), EX_MDo(63 downto 32), EX_MDo(95 downto 64), pause_pipe, miss, write_en, 
			dadosout, enderout, sig_dmout, cont_hits, cont_misses, cont_memaccess);
	MDWB: md_wb port map (finish_in, pause, bubb, cWBo, sig_dmout, EX_MDo(95 downto 64), EX_MDo(100 downto 96), 
			clkMD_WB, cWBo1, MD_WBo, finish_out);
	
	npcj <= EX_MDo(31 downto 0);
	
end arch_memoria_dado;