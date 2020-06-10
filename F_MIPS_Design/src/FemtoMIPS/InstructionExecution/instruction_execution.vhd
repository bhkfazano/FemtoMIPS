library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_execution is
	port( ID_EXout: in std_logic_vector(137 downto 0);
		cWBo: in std_logic_vector(1 downto 0);
		cMDo: in std_logic_vector(2 downto 0);
		cEXo: in std_logic_vector(3 downto 0);
		clkEX_MD: in std_logic;
		
		cWBo1: out std_logic_vector(1 downto 0);
		cMDo1: out std_logic_vector(2 downto 0);
		zero: out std_logic;
		
		EX_MDout: out std_logic_vector(100 downto 0));
end instruction_execution;

architecture arch_instruction_execution of instruction_execution is

	component shift_left_2 is
		port( in1: in std_logic_vector(31 downto 0);
			out1: out std_logic_vector(31 downto 0));
	end component;
	
	component soma is
		port( in1, in2: in std_logic_vector(31 downto 0);
			out1: out std_logic_vector(31 downto 0));
	end component;
	
	component ula is
		port( A, B: in std_logic_vector(31 downto 0);
				ctl: in std_logic_vector(2 downto 0);
				C: out std_logic_vector(31 downto 0);
				zero: out std_logic);
	end component;
	
	component c_ula is
		port( in1: in std_logic_vector(5 downto 0);
			ulaop: in std_logic_vector(1 downto 0);
			out1: std_logic_vector(2 downto 0));
	end component;
	
	component mux_2x1 is
		generic( WIDTH: integer);
		port( in1, in2: in std_logic_vector(WIDTH-1 downto 0);
			sel: in std_logic;
			out1: out std_logic_vector(WIDTH-1 downto 0));
	end component;
	
	component ex_md is
		port( cWBo: in std_logic_vector(1 downto 0);
			cMDo: in std_logic_vector(2 downto 0);
			npcj: in std_logic_vector(31 downto 0);
			zero: in std_logic;
			ulao, reg: in std_logic_vector(31 downto 0);
			endreg: in std_logic_vector(4 downto 0);
			clkEX_MD: in std_logic;
			
			cWBo1: out std_logic_vector(1 downto 0);
			cMDo1: out std_logic_vector(2 downto 0);
			zeroo: out std_logic;
			EX_MDo: out std_logic_vector(100 downto 0));
	end component;
	
	signal sig_sl2, sig_npcj, sig_mx2, sig_ulao: std_logic_vector(31 downto 0);
	signal sig_zero: std_logic;
	signal sig_ctl: std_logic_vector(2 downto 0);
	signal sig_endreg: std_logic_vector(4 downto 0);
	
begin
	SL_2: shift_left_2 port map (ID_EXout(41 downto 10), sig_sl2);
	SOMA2: soma port map (ID_EXout(137 downto 106), sig_sl2, sig_npcj);
	MUX1: mux_2x1 generic map (5) port map (ID_EXout(9 downto 5), ID_EXout(4 downto 0), cEXo(0), sig_endreg);
	MUX2: mux_2x1 generic map (32) port map (ID_EXout(73 downto 42), ID_EXout(41 downto 10), cEXo(3), sig_mx2);
	ContULA: c_ula port map (ID_EXout(15 downto 10), cEXo(2 downto 1), sig_ctl);
	ULArit: ula port map (ID_EXout(105 downto 74), sig_mx2, sig_ctl, sig_ulao, sig_zero);
	EXMD: ex_md port map (cWBo, cMDo, sig_npcj, sig_zero, sig_ulao, ID_EXout(73 downto 42), sig_endreg, clkEX_MD, 
			cWBo1, cMDo1, zero, EX_MDout);
	
end arch_instruction_execution;