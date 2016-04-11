library ieee;
use ieee.std_logic_1164.all;

entity generic_enabler_tb is
end;

architecture generic_enabler_tb_func of generic_enabler_tb is
	signal rst_in: std_logic:='1';
	signal enable_out: std_logic:='0';
	signal clk_in: std_logic:='0';

	component  generic_enabler is

		generic(
		PERIOD:natural := 1000000 --1MHz
		);

		port(
		clk: in std_logic;
		rst: in std_logic;
		enabler_out: out std_logic
		);

	end component;
begin

	clk_in <= not(clk_in) after 1 ns;
	rst_in <= '0' after 10 ns;

	generic_enablerMap: generic_enabler
	generic map(6)
	port map(
	clk => clk_in,
	rst => rst_in,
	enabler_out => enable_out
	);

end architecture;
