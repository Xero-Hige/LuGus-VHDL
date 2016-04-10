library ieee;
use ieee.std_logic_1164.all;

entity generic_enabler is

	generic(
	PERIOD:natural := 1000000 --1MHz
	);

	port(
	clk: in std_logic;
	rst: in std_logic;
	enabler_out: out std_logic
	);

end;

architecture generic_enabler_arq of generic_enabler is

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
		generic_counterMap: generic_counter
			generic map (32,PERIOD) --32 bits son suficientes para hasta 4 GHz

			port map(
			clk => clk,
			rst => rst,
			ena => '1',
			carry_o => enabler_out
			); --El count_dummy esta conectado siempre a tierra.

end;
