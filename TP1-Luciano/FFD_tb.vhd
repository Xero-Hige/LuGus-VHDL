library IEEE;
use IEEE.std_logic_1164.all;

entity FFD_tb is
end;

architecture FFD_sim of FFD_tb is
	signal d_in: std_logic:='0';
	signal rst_in: std_logic:='0';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal q_out: std_logic:='0';
	
	
	component FFD is
	port(
		enable: in std_logic;
		reset: in std_logic;
		clk: in std_logic;
		Q: out std_logic;
		D: in std_logic
		);
	end component;


begin
		clk_in <= not clk_in after 20 ns;
		d_in <= not(d_in) after 40 ns;
		enable_in <= not(enable_in) after 80 ns;
		rst_in <= not(rst_in) after 160 ns;
		
		FDDmap: FFD port map(
			clk => clk_in,
			reset => rst_in,
			enable => enable_in,
			D => d_in,
			Q => q_out
		);


end architecture;
	