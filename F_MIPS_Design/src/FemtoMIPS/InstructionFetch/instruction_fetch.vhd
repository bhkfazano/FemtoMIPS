library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_fetch is
	port( clkIF_ID, clkCInst, clkPC, selPC: in std_logic;
		npcj: in std_logic_vector(31 downto 0);
		IF_IDout: out std_logic_vector(63 downto 0));
end instruction_fetch;

architecture arch_instruction_fetch of instruction_fetch is		 

	component mux_2x1 is
		generic( WIDTH: integer);
		port( in1, in2: in std_logic_vector(WIDTH-1 downto 0);
			sel: in std_logic;
			out1: out std_logic_vector(WIDTH-1 downto 0));
	end component;	
	
	component pc is
		port( pcin: in std_logic_vector(31 downto 0);
			cPC: in std_logic;
			pcout: out std_logic_vector(31 downto 0));
	end component;			
	
	component soma_4 is
		port( in1: in std_logic_vector(31 downto 0);
			out1: out std_logic_vector(31 downto 0));
	end component;
	
	component cache_instrucoes is
		port( end1: in std_logic_vector(31 downto 0);
			clkC: in std_logic;
			dout: out std_logic_vector(31 downto 0));
	end component;	   
	
	component if_id is
		port( npc, inst: in std_logic_vector(31 downto 0);
			cIF_ID: in std_logic;
			out1: out std_logic_vector(63 downto 0));
	end component;

	signal sig_newpc, sig_pc, sig_pc4, sig_inst: std_logic_vector(31 downto 0);
	
begin
	MUX: mux_2x1 generic map (32) port map (sig_pc4, npcj, selPC, sig_newpc);
	PCount: pc port map (sig_newpc, clkPC, sig_pc);	
	SOMA4: soma_4 port map (sig_pc, sig_pc4);
	CACHEINST: cache_instrucoes port map (sig_pc, clkCInst, sig_inst);
	IFID: if_id port map (sig_pc4, sig_inst, clkIF_ID, IF_IDout);
		
end arch_instruction_fetch;