library ieee;
use ieee.std_logic_1164.all;

entity bcd_counter_tb is
end;

architecture bcd_counter_tb_func of bcd_counter_tb is
	signal rst_in: std_logic:='1';
	signal clk_in: std_logic:='0';
	signal ena_in: std_logic:='0';
	signal carry_out: std_logic;
	signal counter_out: std_logic_vector(3 downto 0);

	component bcd_counter is

		port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		counter_out: out std_logic_vector(3 downto 0);
		carry_out: out std_logic
		);

	end component;

begin

	clk_in <= not(clk_in) after 1 ns;
	rst_in <= '0' after 10 ns;
	ena_in <= '1' after 20 ns;

	bcd_counterMap: bcd_counter
	port map(
	clk => clk_in,
	rst => rst_in,
	ena => ena_in,
	counter_out => counter_out,
	carry_out => carry_out
	);

end architecture;
