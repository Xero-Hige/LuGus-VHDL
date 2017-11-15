library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity floating_point_multiplier_tb is
end entity;

architecture floating_point_multiplier_tb_arq of floating_point_multiplier_tb is

	signal number_1_in   : std_logic_vector(22 downto 0) := (others => '0');
	signal number_2_in   : std_logic_vector(22 downto 0) := (others => '0');
	signal result : std_logic_vector(22 downto 0) := (others => '0');

component floating_point_multiplier is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		number1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		multiplication_result: out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);

end component;
	
for floating_point_multiplier_0 : floating_point_multiplier use entity work.floating_point_multiplier;

begin

	floating_point_multiplier_0 : floating_point_multiplier
		generic map(TOTAL_BITS => 23, EXP_BITS => 6)
		port map(
			number1_in => number_1_in,
			number2_in => number_2_in,
			multiplication_result => result
		);

	process
		type pattern_type is record
			n1  : std_logic_vector(22 downto 0);
			n2  : std_logic_vector(22 downto 0);
			r  : std_logic_vector(22 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("11111101111111111111111","00111101010001110011001","11111101010001110011000"),
			("11111101111111111111111","00111101010001110011001","11111101010001110011000")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			number_1_in <= patterns(i).n1;
			number_2_in <= patterns(i).n2;

			wait for 1 ms;

			assert patterns(i).r = result report "EXPECTED: " & integer'image(to_integer(unsigned(patterns(i).r))) & " GOT: " & integer'image(to_integer(unsigned(result)));

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
