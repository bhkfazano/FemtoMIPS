library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_instrucoes is
	port( end1: in std_logic_vector(31 downto 0);
		clkC: in std_logic;
		dout: out std_logic_vector(31 downto 0));
end cache_instrucoes;

-- UMA POTENCIAL BOLHA: "00100000010000100000000000000000"