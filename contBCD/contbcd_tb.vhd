library ieee;
use ieee.std_logic_1164.all;

entity contBCD_tb is
end;

architecture contBCD_tb_func of contBCD is
	signal rst_in: std_logic:='1';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal n_out: std_logic_vector(3 downto 0);
	signal c_out: std_logic;
	
	component contBCD is
		port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		s: out std_logic_vector(3 downto 0);
		co: out std_logic
	);
	end component;
begin

	clk_in <= not(clk_in) after 20 ns;
	rst_in <= '0' after 50 ns;
	enable_in <= '1' after 60 ns;
	
	contadorBCDMap: contBCD port map(
	
		clk => clk_in,
		rst => rst_in,
		ena => enable_in,
		s => n_out,
		co => c_out
	);
		
end architecture;		
