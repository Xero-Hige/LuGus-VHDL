library ieee;
use ieee.std_logic_1164.all;

entity generic_counter_tb is
end;

architecture generic_counter_tb_func of generic_counter_tb is
	signal rst_in: std_logic:='1';
	signal ena_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal n_out: std_logic_vector(3 downto 0);
	signal c_out: std_logic:='0';

	component generic_counter is

		generic (
		BITS:natural := 4;
		MAX_COUNT:natural := 15
		);

		port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		counter_out: out std_logic_vector(BITS-1 downto 0);
		carry_out: out std_logic
		);

	end component;
begin

	clk_in <= not(clk_in) after 1 ns;
	rst_in <= '0' after 10 ns;
	ena_in <= '1' after 20 ns;

	generic_counter_map: generic_counter
	generic map (4,15)
	port map(
	clk => clk_in,
	rst => rst_in,
	ena => ena_in,
	counter_out => n_out,
	carry_out	=> c_out
	);

end architecture;
