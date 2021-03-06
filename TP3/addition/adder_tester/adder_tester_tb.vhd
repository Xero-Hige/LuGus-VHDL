library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; 

entity adder_tester_tb is
	file TEST_FILE : text open READ_MODE is "testing_files/test_sum_float_23_6.txt";
	constant TOTAL_BITS : integer := 23;
	constant EXP_BITS : integer := 6;
	constant PIPELINE_STEPS : integer := 6;
end entity;

architecture adder_tester_tb_arq of adder_tester_tb is

	signal enable_in : std_logic := '0';
	signal reset_in : std_logic := '0';
	signal clk_in : std_logic := '0';
	signal number_1_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number_2_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal result : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal expected_result_before : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal expected_result_after : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	
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

component shift_register is
		generic(REGISTRY_BITS : integer := 32;
	 				STEPS : integer := 4);
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			D: in std_logic_vector(REGISTRY_BITS - 1 downto 0);
			Q: out std_logic_vector(REGISTRY_BITS - 1 downto 0)
		);
 end component;
	
for floating_point_adder_0 : floating_point_adder use entity work.floating_point_adder;
for shift_register_0 : shift_register use entity work.shift_register;


begin

	shift_register_0 : shift_register
		generic map(REGISTRY_BITS => TOTAL_BITS, STEPS => PIPELINE_STEPS + 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => expected_result_before,
			Q => expected_result_after
	);

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
		variable precomputed_result_before : integer;
		variable precomputed_result_after : integer;
		variable to_integer_result : integer;
		variable i : integer := 0;

		begin

		enable_in <= '1';
		clk_in <= '0';

	 	while not endfile(TEST_FILE) loop
	 		readline(TEST_FILE, in_line);
	 		read(in_line, number1_in);
	 		read(in_line, number2_in);
	 		read(in_line, precomputed_result_before);

	 		--report "NUMBER 1: " & integer'image(number1_in);
	 		--report "NUMBER 2: " & integer'image(number2_in);

	 		number_1_in <= std_logic_vector(to_unsigned(number1_in, TOTAL_BITS));
	 		number_2_in <= std_logic_vector(to_unsigned(number2_in, TOTAL_BITS));
	 		expected_result_before <= std_logic_vector(to_unsigned(precomputed_result_before, TOTAL_BITS));

	 		--One clock cycle
	 		clk_in <= '1';

	 		wait for 1 ns;
			
	 		to_integer_result := to_integer(unsigned(result));
	 		precomputed_result_after := to_integer(unsigned(expected_result_after));

	 		--report "REGISTRY RESULT: " & integer'image(precomputed_result_after) & " ADDER RESULT: " & integer'image(to_integer_result);
	 		if(i > PIPELINE_STEPS) then --dont compare in the first iterations because garbage leaves the registers
				assert precomputed_result_after = to_integer_result report "EXPECTED: " & integer'image(precomputed_result_after) & " ACTUAL: " & integer'image(to_integer_result);
			end if;

			clk_in <= '0';

			wait for 1 ns;
			i := i + 1;
		
		end loop;

		--Compare remainder values
		for i in 0 to PIPELINE_STEPS loop
			clk_in <= '1';
			wait for 100 ms;
			
			to_integer_result := to_integer(unsigned(result));
	 		precomputed_result_after := to_integer(unsigned(expected_result_after));
	 		--report "REGISTRY RESULT: " & integer'image(precomputed_result_after) & " ADDER RESULT: " & integer'image(to_integer_result);
	 		assert precomputed_result_after = to_integer_result report "EXPECTED: " & integer'image(precomputed_result_after) & " ACTUAL: " & integer'image(to_integer_result);

	 		clk_in <= '0';

			wait for 1 ns;

	 	end loop;


		assert false report "end of test" severity note;
		wait;
	end process;
end;
