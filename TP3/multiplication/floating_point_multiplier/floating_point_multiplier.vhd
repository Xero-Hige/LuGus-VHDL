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

	signal added_exponents : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exponent_addition_cout: std_logic := '0';

	signal multiplied_mantissas : std_logic_vector(TOTAL_BITS - EXP_BITS downto 0) := (others => '0');

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
			result: out std_logic_vector(BITS + 1 downto 0) --Add one to shift if necessary
		);
	end component;

	component rounder is

		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS: natural := 6
		);

		port (
			exponent_addition_cout: in std_logic;
			man_in: in std_logic_vector(TOTAL_BITS - EXP_BITS downto 0);
			exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
			man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
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

	class_adder_0: class_adder 
		generic map(N => EXP_BITS)
		port map(
			number1_in => exp1,
			number2_in => exp2,
			result => added_exponents,
		  cout => exponent_addition_cout,
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
			exponent_addition_cout => exponent_addition_cout,
			man_in => multiplied_mantissas,
			exp_in => added_exponents,
			man_out => result_man,
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
					added_exponents,
					exponent_addition_cout,
					multiplied_mantissas,
					result_man,
					result_exp,
					result_sign) is
	
	variable int_1: integer := 0;
	variable int_2 : integer := 0;
	begin
		int_1 := to_integer(unsigned(number1_in));
		int_2 := to_integer(unsigned(number2_in));
		
		number1 <= number1_in;
		number2 <= number2_in;
		
		if(int_1 = 0 or int_2 = 0) then
			multiplication_result <= (others => '0');
		else 
			multiplication_result <= result_sign & result_exp & result_man;
		end if;
	
		
	end process;

end;
