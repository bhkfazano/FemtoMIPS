library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_dados is
	port( endr, endw, dataw: in std_logic_vector(31 downto 0);
		memRead, memWrite: in std_logic;		
		datao: out std_logic_vector(31 downto 0));
end cache_dados;