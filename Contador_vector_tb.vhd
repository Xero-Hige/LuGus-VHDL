library IEEE;
use IEEE.std_logic_1164.all;

entity contador_vector_tb is
end;

architecture contador_sim of contador_vector_tb is
	
	signal rst_in: std_logic:='1';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal Q_out: std_logic_vector(1 downto 0);
	
	component contador_vector is
	port(
		rst_c: in std_logic;
		clk_c: in std_logic;
		enable_c: in std_logic;
		Q: out std_logic_vector(1 downto 0)
	);
	end component;


begin
		clk_in <= not clk_in after 20 ns;
		enable_in <= '1' after 100 ns;
		--enable_in <= not(enable_in)) after 100 ns; //Para probar que funciona el enable
		rst_in <= '0' after 50 ns;
		
		
	
		
		
		
		ContadorMap: contador_vector port map(
			clk_c => clk_in,
			rst_c => rst_in,
			enable_c => enable_in,
			Q => Q_out
		);


end architecture;
	