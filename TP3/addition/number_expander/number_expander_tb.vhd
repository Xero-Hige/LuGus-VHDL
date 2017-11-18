library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity number_expander_tb is
end entity;

architecture number_expander_tb_arq of number_expander_tb is

	signal number_in   : std_logic_vector(15 downto 0) := (others => '0');
	signal number_out  : std_logic_vector(16 downto 0) := (others => '0');

	component number_expander is
		generic(
			BITS : natural := 16
		);

		port(
			number_in   : in  std_logic_vector(BITS - 1 downto 0);
			number_out  : out  std_logic_vector(BITS  downto 0)
		);
	end component;
	
	for number_expander_0 : number_expander use entity work.number_expander;

begin

	number_expander_0 : number_expander
		generic map(BITS => 16)
		port map(
			number_in   => number_in,
			number_out  => number_out
		);

	process
		type pattern_type is record
			ni  : std_logic_vector(15 downto 0);
			no  : std_logic_vector(16 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000000000","10000000000000000"),
			("1111111111111111","11111111111111111"),
			("1010101010101010","11010101010101010")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			number_in <= patterns(i).ni;
			wait for 1 ns;

			assert patterns(i).no = number_out report "BAD NUMBER, GOT: " & integer'image(to_integer(unsigned(number_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
