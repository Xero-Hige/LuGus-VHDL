library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity floating_point_adder_tb is
end entity;

architecture floating_point_adder_tb_arq of floating_point_adder_tb is

	signal number_1_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal number_2_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal result : std_logic_vector(31 downto 0) := (others => '0');

component floating_point_adder is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		number_1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number_2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		result: out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);

end component;
	
for floating_point_adder_0 : floating_point_adder use entity work.floating_point_adder;

begin

	floating_point_adder_0 : floating_point_adder
		generic map(TOTAL_BITS => 32, EXP_BITS => 8)
		port map(
			number_1_in => number_1_in,
			number_2_in => number_2_in,
			result => result
		);

	process
		type pattern_type is record
			n1  : std_logic_vector(31 downto 0);
			n2  : std_logic_vector(31 downto 0);
			r  : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000"),
			("01000010110010000000000000000000","00111110110000000000000000000000","01000010110010001100000000000000")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			number_1_in <= patterns(i).n1;
			number_2_in <= patterns(i).n2;

			wait for 1 ms;

			assert patterns(i).r = result report "BAD RESULT, GOT: " & integer'image(to_integer(unsigned(result)));

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
