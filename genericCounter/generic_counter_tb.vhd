library ieee;
use ieee.std_logic_1164.all;

entity genericCounter_tb is
end;

architecture genericCounter_tb_func of genericCounter_tb is
	signal rst_in: std_logic:='1';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal n_out: std_logic_vector(3 downto 0);
	signal c_out: std_logic:='0';
	
	component genericCounter is
		generic (
			BITS:natural := 4;
			MAX_COUNT:natural := 15);
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			count: out std_logic_vector(BITS-1 downto 0);
			carry_o: out std_logic
		);
	end component;
begin

	clk_in <= not(clk_in) after 20 ns;
	rst_in <= '0' after 50 ns;
	enable_in <= '1' after 60 ns;
	
	genericCounterMap: genericCounter generic map (4,10)
		port map(
	
			clk => clk_in,
			rst => rst_in,
			ena => enable_in,
			count => n_out,
			carry_o => c_out
		);
		
end architecture;		
