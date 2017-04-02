library IEEE;
use IEEE.std_logic_1164.all;

entity contador_tb is
end;

architecture contador_sim of contador_tb is
	signal rst_in: std_logic:='1';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal q0_out: std_logic:='0';
	signal q1_out: std_logic:='0';
	
	
	component contador is
	port(
		rst_c: in std_logic;
		clk_c: in std_logic;
		enable_c: in std_logic;
		q1_c: out std_logic;
		q0_c: out std_logic
	);
	end component;


begin
		clk_in <= not clk_in after 20 ns;
		enable_in <= '1' after 100 ns;
		rst_in <= '0' after 50 ns;
		
		ContadorMap: contador port map(
			clk_c => clk_in,
			rst_c => rst_in,
			enable_c => enable_in,
			q1_c => q1_out,
			q0_c => q0_out
		);


end architecture;
	