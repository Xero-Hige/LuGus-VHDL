library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity floating_point_multiplier is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		number1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		multiplication_result : out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);

end floating_point_multiplier;

architecture floating_point_multiplier_arq of floating_point_multiplier is

	signal number1 : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number2 : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');

	signal man1 : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal man2 : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal exp1 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp2 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal sign1 : std_logic := '0';
	signal sign2 : std_logic := '0';

	signal unbiased_exp1 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal unbiased_exp2 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

	signal added_exponents : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

	signal multiplied_mantissas : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');

	signal rounded_added_exponents : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

	signal result_man : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal result_exp : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal result_sign : std_logic := '0';

	component number_splitter is
		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS:natural := 6);
		port (

			number_in: in std_logic_vector(TOTAL_BITS-1 downto 0);
			sign_out: out std_logic;
			exp_out: out std_logic_vector(EXP_BITS-1 downto 0);
			mant_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0)
		);
	end component;

	component class_adder is
		generic(N: integer:= 4);
		port(
				 number1_in: in std_logic_vector(N-1 downto 0);
				 number2_in: in std_logic_vector(N-1 downto 0);
				 cin:        in std_logic;

				 result:     out std_logic_vector(N-1 downto 0);
				 cout:       out std_logic
		);

  end component;

  component mantissa_multiplier is

		generic(
			BITS:natural := 16
		);

		port (
			man1_in: in std_logic_vector(BITS - 1 downto 0);
			man2_in: in std_logic_vector(BITS - 1 downto 0);
			result: out std_logic_vector(BITS downto 0) --Add one to shift if necessary
		);
	end component;

	component rounder is

		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS: natural := 6
		);

		port (
			man_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0);
			exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
			man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;

	component biaser is

		generic(
			EXP_BITS: natural := 6
		);

		port (
			operation : in std_logic;
			exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;

	component sign_computer is
  port(
    sign1_in : in std_logic;
    sign2_in : in std_logic;
    sign_out : out std_logic
  );
	end component;
	
	for sign_computer_0 : sign_computer use entity work.sign_computer;
	for mantissa_multiplier_0: mantissa_multiplier use entity work.mantissa_multiplier;
	for class_adder_0: class_adder use entity work.class_adder;
	for rounder_0: rounder use entity work.rounder;
	for biaser_0: biaser use entity work.biaser;
	for biaser_1: biaser use entity work.biaser;
	for biaser_2: biaser use entity work.biaser;
	for number_splitter_1 : number_splitter use entity work.number_splitter;
	for number_splitter_2 : number_splitter use entity work.number_splitter;


begin

	number_splitter_1: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number1,
			sign_out => sign1,
			exp_out => exp1,
			mant_out => man1
		);

	number_splitter_2: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number2,
			sign_out => sign2,
			exp_out => exp2,
			mant_out => man2
		);

	biaser_1: biaser
		generic map(EXP_BITS => EXP_BITS)
		port map(
			operation => '1',
			exp_in => exp1,
			exp_out => unbiased_exp1
		);

	biaser_2: biaser
		generic map(EXP_BITS => EXP_BITS)
		port map(
			operation => '1',
			exp_in => exp2,
			exp_out => unbiased_exp2
		);

	class_adder_0: class_adder 
		generic map(N => EXP_BITS)
		port map(
			number1_in => unbiased_exp1,
			number2_in => unbiased_exp2,
			result => added_exponents,
		  cout => open,
			cin => '0'
	);

	mantissa_multiplier_0: mantissa_multiplier 
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			man1_in => man1,
			man2_in => man2,
			result => multiplied_mantissas
		);

	rounder_0: rounder 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			man_in => multiplied_mantissas,
			exp_in => added_exponents,
			man_out => result_man,
			exp_out => rounded_added_exponents
		);

	biaser_0: biaser
		generic map(EXP_BITS => EXP_BITS)
		port map(
			operation => '0',
			exp_in => rounded_added_exponents,
			exp_out => result_exp
		);


	sign_computer_0: sign_computer 
		port map(
			sign1_in => sign1,
			sign2_in => sign2,
			sign_out => result_sign
	);

	process(number1_in,
					number2_in,
					number1,
					number2,
					man1,
					man2,
					exp1,
					exp2,
					sign1,
					sign2,
					unbiased_exp1,
					unbiased_exp2,
					added_exponents,
					multiplied_mantissas,
					result_man,
					result_exp,
					result_sign) is
		
	begin

		number1 <= number1_in;
		number2 <= number2_in;
	
		multiplication_result <= result_sign & result_exp & result_man;
	end process;

end;