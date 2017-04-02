library ieee;
use ieee.std_logic_1164.all;
use work.utility.all;

entity bcd_1_counter_tb is
end;

architecture bcd_1_counter_tb_func of bcd_1_counter_tb is
	signal rst_in: std_logic:='1';
	signal clk_in: std_logic:='0';
	signal ena_in: std_logic:='0';
	signal counter_out: bcd_vector (2 downto 0);

	component bcd_1_counter is

		generic (
			COUNTERS:natural := 5;
			OUTPUT:natural := 3
		);

		port (
			clk_in: in std_logic;
			rst_in: in std_logic;
			ena_in: in std_logic;
			counter_out: out bcd_vector ( OUTPUT-1 downto 0)
		);

	end component;

begin

	clk_in <= not(clk_in) after 1 ns;
	rst_in <= '0' after 10 ns;
	ena_in <= '1' after 20 ns;

	bcd_1_counterMap: bcd_1_counter generic map(5,3)
	port map(
		clk_in => clk_in,
		rst_in => rst_in,
		ena_in => ena_in,
		counter_out => counter_out
	);

end architecture;