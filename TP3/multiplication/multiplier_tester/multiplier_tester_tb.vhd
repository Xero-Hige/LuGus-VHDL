library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; 

entity multiplier_tester_tb is
	file TEST_FILE : text open READ_MODE is "testing_files/test_mul_float_23_6.txt";
	constant TOTAL_BITS : integer := 23;
	constant EXP_BITS : integer := 6;
end entity;

architecture multiplier_tester_tb_arq of multiplier_tester_tb is

	signal number_1_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number_2_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal result : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	
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
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number1_in => number_1_in,
			number2_in => number_2_in,
			multiplication_result => result
	);

	process
		variable in_line : line;
		variable number1_in : integer;
		variable number2_in : integer;
		variable precomputed_result : integer;
		variable to_integer_result : integer;

		begin

	 	while not endfile(TEST_FILE) loop
	 		readline(TEST_FILE, in_line);
	 		read(in_line, number1_in);
	 		read(in_line, number2_in);
	 		read(in_line, precomputed_result);

	 		--report "NUMBER 1: " & integer'image(number1_in);
	 		--report "NUMBER 2: " & integer'image(number2_in);

	 		number_1_in <= std_logic_vector(to_unsigned(number1_in, TOTAL_BITS));
	 		number_2_in <= std_logic_vector(to_unsigned(number2_in, TOTAL_BITS));

	 		wait for 100 ms;
			
	 		to_integer_result := to_integer(unsigned(result));
	 		report "INPUT 1: " & integer'image(number1_in);
	 		report "INPUT 2: " & integer'image(number2_in);
			assert precomputed_result = to_integer_result report "EXPECTED: " & integer'image(precomputed_result) & " ACTUAL: " & integer'image(to_integer_result);

	 	end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;