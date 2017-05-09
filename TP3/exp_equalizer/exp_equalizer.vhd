library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component takes 2 numbers written in scientific notation and returns the same numbers with the same exponent

entity exp_equalizer is

	generic(
		TOTAL_BITS:natural := 23;
		EXP_BITS:natural := 6
	);

	port (
		man_1_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_1_in: in std_logic_vector(EXP_BITS-1 downto 0);
		man_2_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_2_in: in std_logic_vector(EXP_BITS-1 downto 0);
		man_1_out: out std_logic_vector((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto 0); --extended precision
		man_2_out: out std_logic_vector((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto 0);
		exp_out: out std_logic_vector(EXP_BITS-1 downto 0);
		difference: out unsigned(EXP_BITS-1 downto 0)
	);
end;

architecture exp_equalizer_arq of exp_equalizer is

	signal exp_1: std_logic_vector(EXP_BITS-1 downto 0);
	signal exp_2: std_logic_vector(EXP_BITS-1 downto 0);
	signal man_1: std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
	signal man_2: std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
	signal comparer_greater: std_logic;
	signal comparer_smaller: std_logic;
	signal smaller_exp: std_logic_vector(EXP_BITS-1 downto 0);
	signal greater_exp: std_logic_vector(EXP_BITS-1 downto 0);
	signal smaller_man: std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
	signal greater_man: std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);



	component comparer is
		generic(
			BITS:natural := 16
		);

		port (
			number1_in: in  std_logic_vector(BITS-1 downto 0);
			number2_in: in  std_logic_vector(BITS-1 downto 0);
			first_greater: out std_logic;
			second_greater: out std_logic;
			equals: out std_logic
		);
	end component;
	for comparer_0: comparer use entity work.comparer;


	component binary_multiplexer is
		generic(
			BITS:natural := 16
		);

    port(
	    number1_in: in  std_logic_vector(BITS-1 downto 0);
	    number2_in: in  std_logic_vector(BITS-1 downto 0);

	    chooser: in std_logic;

	    mux_output: out  std_logic_vector(BITS-1 downto 0)
    );
	end component;
	for greater_exp_mux: binary_multiplexer use entity work.binary_multiplexer;
	for smaller_exp_mux: binary_multiplexer use entity work.binary_multiplexer;
	for greater_man_mux: binary_multiplexer use entity work.binary_multiplexer;
	for smaller_man_mux: binary_multiplexer use entity work.binary_multiplexer;



begin

	comparer_0: comparer
		generic map( BITS => EXP_BITS )
		port map (
			first_greater => comparer_smaller,
			second_greater => comparer_greater,
			number1_in => exp_1,
			number2_in => exp_2
		);

	greater_exp_mux: binary_multiplexer
		generic map( BITS => EXP_BITS )
		port map(
			chooser => comparer_greater,
			number1_in => exp_1,
			number2_in => exp_2,
			mux_output => greater_exp
		);

	smaller_exp_mux: binary_multiplexer
		generic map( BITS => EXP_BITS )
		port map(
			chooser => comparer_smaller,
			number1_in => exp_1,
			number2_in => exp_2,
			mux_output => smaller_exp
		);

	greater_man_mux: binary_multiplexer
		generic map( BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			chooser => comparer_greater,
			number1_in => man_1,
			number2_in => man_2,
			mux_output => greater_man
		);
	smaller_man_mux: binary_multiplexer
		generic map( BITS => TOTAL_BITS - EXP_BITS - 1)
		port map (
			chooser => comparer_smaller,
			number1_in => man_1,
			number2_in => man_2,
			mux_output => smaller_man
		);

	process(man_1_in, exp_1_in, man_2_in, exp_2_in, greater_exp, smaller_exp, smaller_man, greater_man)
		variable shifting_difference: unsigned(EXP_BITS-1 downto 0);
		variable extended_man_greater: std_logic_vector((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto 0) := (others => '0');
		variable extended_man_smaller: std_logic_vector((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto 0) := (others => '0');
	begin


		exp_1 <= exp_1_in;
		exp_2 <= exp_2_in;
		extended_man_greater((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto (TOTAL_BITS - EXP_BITS - 1)) := greater_man;
		extended_man_smaller((TOTAL_BITS - EXP_BITS - 1) * 2 - 1 downto (TOTAL_BITS - EXP_BITS - 1)) := smaller_man;
		report "GM" & integer'image(to_integer(unsigned(greater_man)));
		report "EMG" & integer'image(to_integer(unsigned(extended_man_greater)));
		report "GE" & integer'image(to_integer(unsigned(greater_exp)));
		shifting_difference := unsigned(greater_exp) - unsigned(smaller_exp);
		man_1_out <= std_logic_vector(shift_right(unsigned(extended_man_smaller),to_integer(shifting_difference)));
		man_2_out <= extended_man_greater;
		exp_out <= greater_exp;

	end process;

end architecture;
