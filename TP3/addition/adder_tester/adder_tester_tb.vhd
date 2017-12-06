library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; 

entity adder_tester_tb is
	file TEST_FILE : text open READ_MODE is "testing_files/test_sum_float_23_6.txt";
	constant TOTAL_BITS : integer := 23;
	constant EXP_BITS : integer := 6;
end entity;

architecture adder_tester_tb_arq of adder_tester_tb is

	signal enable_in : std_logic := '0';
	signal reset_in : std_logic := '0';
	signal clk_in : std_logic := '0';
	signal number_1_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number_2_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal result : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	
	component floating_point_adder is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		enable : in std_logic;
		reset : in std_logic;
		clk : in std_logic;
		number_1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number_2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		result: out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);

end component;
	
for floating_point_adder_0 : floating_point_adder use entity work.floating_point_adder;


begin

	floating_point_adder_0 : floating_point_adder
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			number_1_in => number_1_in,
			number_2_in => number_2_in,
			result => result
	);

	process
		variable in_line : line;
		variable number1_in : integer;
		variable number2_in : integer;
		variable precomputed_result : integer;
		variable to_integer_result : integer;

		begin

		enable_in <= '1';
		clk_in <= '0';

	 	while not endfile(TEST_FILE) loop
	 		readline(TEST_FILE, in_line);
	 		read(in_line, number1_in);
	 		read(in_line, number2_in);
	 		read(in_line, precomputed_result);

	 		--report "NUMBER 1: " & integer'image(number1_in);
	 		--report "NUMBER 2: " & integer'image(number2_in);

	 		number_1_in <= std_logic_vector(to_unsigned(number1_in, TOTAL_BITS));
	 		number_2_in <= std_logic_vector(to_unsigned(number2_in, TOTAL_BITS));

	 		--One clock cycle
	 		clk_in <= '1';

	 		wait for 100 ms;
			
	 		to_integer_result := to_integer(unsigned(result));
			assert precomputed_result = to_integer_result report "EXPECTED: " & integer'image(precomputed_result) & " ACTUAL: " & integer'image(to_integer_result);

			clk_in <= '0';

			wait for 100 ms;

	 	end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
