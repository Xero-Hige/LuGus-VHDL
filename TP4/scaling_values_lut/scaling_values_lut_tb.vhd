library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scaling_values_lut_tb is
end entity;

architecture scaling_values_lut_tb_arq of scaling_values_lut_tb is

	signal steps  : integer := 0;
	signal scaling_value : std_logic_vector(31 downto 0) := (others => '0');

	component scaling_values_lut is
		generic(TOTAL_BITS: integer := 32);
	  port(
	    steps: in integer := 0;
	    scaling_value: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
	  );
	end component;

	for scaling_values_lut_0 : scaling_values_lut use entity work.scaling_values_lut;

begin

	scaling_values_lut_0 : scaling_values_lut
		generic map(TOTAL_BITS => 32)
		port map(
			steps  => steps,
			scaling_value => scaling_value
		);

	process
		type pattern_type is record
			i : integer;
			sv : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			(1,"00000000000000000000101101010000"),
			(6,"00000000000000000000100110110111"),
			(20,"00000000000000000000100110110111")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			steps <= patterns(i).i;

			wait for 1 ns;

			assert patterns(i).sv = scaling_value report "BAD SCALING VALUE, GOT: " & integer'image(to_integer(unsigned(scaling_value)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
