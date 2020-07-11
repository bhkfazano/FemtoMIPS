library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwarding is
	port( pause_pipe, clk: in std_logic;
		ant_endrega, ant_endregb: in std_logic_vector(4 downto 0);
		
		endreg_md, endreg_wb: in std_logic_vector(4 downto 0);
		cWB_md: in std_logic_vector(1 downto 0);
		cWB_wb: in std_logic;
		
		mux1_ctl, mux2_ctl: out std_logic_vector(1 downto 0);
		fwd_pause_ifid, fwd_bubb_ex: out std_logic);
end forwarding;

architecture arch_forwarding of forwarding is

	signal sig_ant_endrega, sig_ant_endregb: std_logic_vector(4 downto 0) := (others => '0');

	signal sig_mux1_ctl, sig_mux2_ctl: std_logic_vector(1 downto 0) := "00";
	signal sig_fwd_pause_ifid, sig_fwd_bubb_ex: std_logic := '0';
begin
	process is
	begin
		wait until falling_edge (clk);
		wait for 0.1 ns;
		if sig_fwd_pause_ifid = '0' and pause_pipe = '0' then
			sig_ant_endrega <= ant_endrega;
			sig_ant_endregb <= ant_endregb;
		end if;
	end process;
	
	process is
	begin
		wait until rising_edge (clk);
		wait for 0.1 ns;
		sig_mux1_ctl <= "00";
		sig_mux2_ctl <= "00";
		sig_fwd_pause_ifid <= '0';
		sig_fwd_bubb_ex <= '0';
		
		if sig_ant_endrega /= "00000" then
			if sig_ant_endrega = endreg_md then
				if cWB_md = "11" then
					sig_mux1_ctl <= "01";
				elsif cWB_md = "10" then
					sig_fwd_pause_ifid <= '1';
					sig_fwd_bubb_ex <= '1';
				end if;
			elsif sig_ant_endrega = endreg_wb and cWB_wb = '1' then
				sig_mux1_ctl <= "10";
			end if;
		end if;
		
		if sig_ant_endregb /= "00000" then
			if sig_ant_endregb = endreg_md then
				if cWB_md = "11" then
					sig_mux2_ctl <= "01";
				elsif cWB_md = "10" then
					sig_fwd_pause_ifid <= '1';
					sig_fwd_bubb_ex <= '1';
				end if;
			elsif sig_ant_endregb = endreg_wb and cWB_wb = '1' then
				sig_mux2_ctl <= "10";
			end if;
		end if;
	end process;
	
	mux1_ctl <= sig_mux1_ctl;
	mux2_ctl <= sig_mux2_ctl;
	fwd_pause_ifid <= sig_fwd_pause_ifid;
	fwd_bubb_ex <= sig_fwd_bubb_ex;
	
end arch_forwarding;