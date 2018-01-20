library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enable_generator_tb is
end entity;

architecture enable_generator_tb_arq of enable_generator_tb is

	signal enable_in : std_logic := '0';
  signal clk : std_logic := '0';
  signal enable_out : std_logic := '0';

	component enable_generator is

    generic(CYCLE_COUNT: integer := 10);
		port(
			clk: in std_logic := '0';
			enable_in: in std_logic := '0';
			enable_out : out std_logic := '0'
		);
	end component;

begin

	enable_generator_0 : enable_generator
		port map(
			enable_in => enable_in,
			clk => clk,
			enable_out => enable_out
		);

	process

		type pattern_array is array (natural range <>) of std_logic;
		constant patterns : pattern_array := (('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('0'),('1'),('0'),('0'));


	begin
		enable_in <= '1';

		for i in patterns'range loop

			clk <= '0';
			wait for 1 ns;
			clk	<= '1';

			assert patterns(i) = enable_out report "BAD VALUE, EXPECTED: " & std_logic'image(patterns(i)) & " GOT: " & std_logic'image(enable_out);
			wait for 1 ns;
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
