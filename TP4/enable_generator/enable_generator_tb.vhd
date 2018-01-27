library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enable_generator_tb is
end entity;

architecture enable_generator_tb_arq of enable_generator_tb is

	signal enable_in : std_logic := '0';
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal enable_out : std_logic := '0';

	component enable_generator is

		generic(CYCLE_COUNT: integer := 10; PASSIVE_CYCLES: integer := 0; ACTIVE_CYCLES: integer := 0);
		port(
			rst : in std_logic := '0';
			clk: in std_logic := '0';
			enable_in: in std_logic := '0';
			enable_out : out std_logic := '0'
		);
	end component;

begin

	enable_generator_0 : enable_generator
		generic map(CYCLE_COUNT => 2, PASSIVE_CYCLES => 3, ACTIVE_CYCLES => 2)
		port map(
			rst => rst,
			enable_in => enable_in,
			clk => clk,
			enable_out => enable_out
		);

	process
	begin
		enable_in <= '1';

		for i in 0 to 100 loop

			clk <= '0';
			wait for 1 ns;
			clk	<= '1';
			wait for 1 ns;
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
