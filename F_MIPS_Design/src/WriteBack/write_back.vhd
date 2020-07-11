library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity write_back is
	port( MD_WBo: in std_logic_vector(68 downto 0);
		cWBo: in std_logic_vector(1 downto 0);
		clkW: in std_logic;
		
		regWrite: out std_logic;
		enderw: out std_logic_vector(4 downto 0);
		dataw: out std_logic_vector(31 downto 0));
end write_back;

architecture arch_write_back of write_back is

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
	
begin
	MUX: mux_2x1 generic map (32) port map (MD_WBo(31 downto 0), MD_WBo(63 downto 32), cWBo(0), dataw);
	AND_2: and2 port map (cWBo(1), clkW, regWrite);
	
	enderw <= MD_WBo(68 downto 64);
	
end arch_write_back;