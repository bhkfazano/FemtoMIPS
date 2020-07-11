library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity femto_MIPS is
	--port( write_atual: in std_logic;
		--ender_atual: in std_logic_vector(31 downto 0);
		--pronto: in std_logic;
		--dadosin: in std_logic_vector(127 downto 0);
		--write_en, cached_miss: out std_logic;
		--dadosout, enderout_i, enderout_d: out std_logic_vector(31 downto 0));
end femto_MIPS;

architecture arch_femto_MIPS of femto_MIPS is

	component clock_10ns is
		port( clk: out std_logic);
	end component;
	
	component forwarding is
		port( pause_pipe, clk: in std_logic;
			ant_endrega, ant_endregb: in std_logic_vector(4 downto 0);
			
			endreg_md, endreg_wb: in std_logic_vector(4 downto 0);
			cWB_md: in std_logic_vector(1 downto 0);
			cWB_wb: in std_logic;
			
			mux1_ctl, mux2_ctl: out std_logic_vector(1 downto 0);
			fwd_pause_ifid, fwd_bubb_ex: out std_logic);
	end component;
	
	component instruction_fetch is
		port( write_atual: in std_logic;
			ender_atual: in std_logic_vector(31 downto 0);
			cont_en, pause, bubb: in std_logic;
			clkIF_ID, clkCInst, clkPC, selPC, pronto: in std_logic;
			npcj: in std_logic_vector(31 downto 0);
			dadosin: in std_logic_vector(127 downto 0);
			freeze_count: out std_logic;
			enderout: out std_logic_vector(31 downto 0);
			IF_IDout: out std_logic_vector(63 downto 0));
	end component;
	
	component instruction_decode is
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
	end component;
	
	component instruction_execution is
		port( pause, bubb: in std_logic;
			reg_md, dataw: in std_logic_vector(31 downto 0);
			mux1_ctl, mux2_ctl: in std_logic_vector(1 downto 0);
			ID_EXout: in std_logic_vector(137 downto 0);
			cWBo: in std_logic_vector(1 downto 0);
			cMDo: in std_logic_vector(2 downto 0);
			cEXo: in std_logic_vector(9 downto 0);
			clkEX_MD: in std_logic;
			jump_to: in std_logic_vector(31 downto 0);
			
			cWBo1: out std_logic_vector(1 downto 0);
			cMDo1: out std_logic_vector(2 downto 0);
			zero: out std_logic;
			
			EX_MDout: out std_logic_vector(100 downto 0));
	end component;
	
	component memoria_dado is
		port( write_atual, pause, bubb, pronto: in std_logic;
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
			
			MD_WBo: out std_logic_vector(68 downto 0));
	end component;
	
	component write_back is
		port( MD_WBo: in std_logic_vector(68 downto 0);
			cWBo: in std_logic_vector(1 downto 0);
			clkW: in std_logic;
			
			regWrite: out std_logic;
			enderw: out std_logic_vector(4 downto 0);
			dataw: out std_logic_vector(31 downto 0));
	end component;
	
	component memoria_principal is
		port( enable, write_en: in std_logic;
			dadosin, ender: in std_logic_vector(31 downto 0);
			pronto, write_atual: out std_logic;
			ender_atual: out std_logic_vector(31 downto 0);
			dados: out std_logic_vector(127 downto 0));
	end component;
	
	component mux_2x1 is
		generic( WIDTH: integer);
		port( in1, in2: in std_logic_vector(WIDTH-1 downto 0);
			sel: in std_logic;
			out1: out std_logic_vector(WIDTH-1 downto 0));
	end component;
	
	component and2 is
		port( in1, in2: in std_logic;
			out1: out std_logic);
	end component;
	
	signal sig_clk: std_logic;
	
	signal sigIF_IF_IDout: std_logic_vector(63 downto 0);
	
	signal sigID_cWBo: std_logic_vector(1 downto 0);
	signal sigID_cMDo: std_logic_vector(2 downto 0);
	signal sigID_cEXo: std_logic_vector(9 downto 0);
	signal sigID_ID_EXout: std_logic_vector(137 downto 0);
	signal sigID_jump_to: std_logic_vector(31 downto 0);
	
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
	
	signal const_zero: std_logic_vector(137 downto 0) := (others => '0');
	
	signal sig_mux1_ctl, sig_mux2_ctl: std_logic_vector(1 downto 0) := "00";
	signal sig_fwd_pause_ifid, sig_fwd_bubb_ex: std_logic := '0';
	
	signal sig_cont_en: std_logic := '1';
	signal pause_if, bubb_if: std_logic := '0';
	signal pause_id, bubb_id: std_logic := '0';
	signal pause_ex, bubb_ex: std_logic := '0';
	signal pause_md, bubb_md: std_logic := '0';
	
	signal sigIF_freeze_count, sigMD_pause_pipe: std_logic := '0';
	
	--write_atual: in std_logic;
	--ender_atual: in std_logic_vector(31 downto 0);
	--pronto: in std_logic;
	--dadosin: in std_logic_vector(127 downto 0);
	signal sigFM_write_en, sigFM_cached_miss: std_logic := '0';
	signal sigFM_dadosout, sigFM_enderout_i, sigFM_enderout_d: std_logic_vector(31 downto 0) := (others => '0');
	
	signal sigMP_pronto, sigMP_write_atual: std_logic := '0';
	signal sigMP_ender_atual: std_logic_vector(31 downto 0) := (others => '0');
	signal sigMP_dados: std_logic_vector(127 downto 0) := (others => '0');
	
	signal sigout_mux: std_logic_vector(31 downto 0) := (others => '0');
	signal sigout_and: std_logic := '0';

begin
	CLK_10: clock_10ns port map (sig_clk);
	FWD: forwarding port map (sigMD_pause_pipe, sig_clk, sigIF_IF_IDout(57 downto 53), sigIF_IF_IDout(52 downto 48), 
			sigEX_EX_MDout(100 downto 96), sigMD_MD_WBo(68 downto 64), sigEX_cWBo1, sigMD_cWBo1(1), 
			sig_mux1_ctl, sig_mux2_ctl, sig_fwd_pause_ifid, sig_fwd_bubb_ex);
			
	I_F: instruction_fetch port map (sigMP_write_atual, sigMP_ender_atual, sig_cont_en, pause_if, bubb_if, sig_clk, 
			sig_clk, sig_clk, sigMD_pcsrc, sigMP_pronto, sigMD_npcj, sigMP_dados, sigIF_freeze_count, 
			sigFM_enderout_i, sigIF_IF_IDout);
	I_D: instruction_decode port map (pause_id, bubb_id, sigIF_IF_IDout, sigWB_dataw, sigWB_enderw, sigWB_regWrite, 
			sig_clk, sigID_cWBo, sigID_cMDo, sigID_cEXo, sigID_ID_EXout, sigID_jump_to);
	E_X: instruction_execution port map (pause_ex, bubb_ex, sigEX_EX_MDout(95 downto 64), sigWB_dataw, sig_mux1_ctl, 
			sig_mux2_ctl, sigID_ID_EXout, sigID_cWBo, sigID_cMDo, sigID_cEXo, sig_clk, sigID_jump_to, sigEX_cWBo1, 
			sigEX_cMDo1, sigEX_zero, sigEX_EX_MDout);
	M_D: memoria_dado port map (sigMP_write_atual, pause_md, bubb_md, sigMP_pronto, sigMP_ender_atual, 
			sigEX_EX_MDout, sigEX_cWBo1, sigEX_cMDo1, sigEX_zero, sig_clk, sigMP_dados, sigMD_pause_pipe, 
			sigFM_cached_miss, sigFM_write_en, sigFM_dadosout, sigFM_enderout_d, sigMD_npcj, sigMD_pcsrc, 
			sigMD_cWBo1, sigMD_MD_WBo);
	W_B: write_back port map (sigMD_MD_WBo, sigMD_cWBo1, sig_clk, sigWB_regWrite, sigWB_enderw, sigWB_dataw);
	
	--cached_miss <= sigMD_cached_miss;
	
	MUX: mux_2x1 generic map (32) port map (sigFM_enderout_i, sigFM_enderout_d, sigFM_cached_miss, sigout_mux);
	AND_2: and2 port map (sigFM_cached_miss, sigFM_write_en, sigout_and);
	--F_MIPS: femto_MIPS port map (sigMP_write_atual, sigMP_ender_atual, sigMP_pronto, sigMP_dados, sigFM_write_en, 
			--sigFM_cached_miss, sigFM_dadosout, sigFM_enderout_i, sigFM_enderout_d);
	MEM_PRINC: memoria_principal port map ('1', sigout_and, sigFM_dadosout, sigout_mux, sigMP_pronto, 
			sigMP_write_atual, sigMP_ender_atual, sigMP_dados);
	
	-- Sempre em atualização.
	-- Até aqui, cobre esperas para aguardar leituras no cache de dados em caso de dependência e bolhas para 
	-- o caso de branches efetivados.
	sig_cont_en <= (not sig_fwd_pause_ifid) and (not sigIF_freeze_count) and (not sigMD_pause_pipe);
	pause_if <= sig_fwd_pause_ifid or sigMD_pause_pipe;
	bubb_if <= sigMD_pcsrc;
	pause_id <= sig_fwd_pause_ifid or sigMD_pause_pipe;
	bubb_id <= sigMD_pcsrc;
	pause_ex <= sigMD_pause_pipe;
	bubb_ex <= sig_fwd_bubb_ex or sigMD_pcsrc;
	--pause_md <= 
	bubb_md <= sigMD_pause_pipe;
	
end arch_femto_MIPS;