library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component takes 2 numbers written in scientific notation returns the sum of them, also in scientific notation.

entity floating_point_adder is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		number_1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number_2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		result: out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);
end floating_point_adder;

architecture floating_point_adder_arq of floating_point_adder is

	signal number_1 :  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number_2 :  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');

	signal man_1 : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0'); 
	signal man_2 : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal exp_1 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_2 : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal sign_1 : std_logic := '0';
	signal sign_2 : std_logic := '0';

	signal man_greater : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal man_smaller : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal exp_greater : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_smaller : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

	signal expanded_man_smaller : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');
	signal expanded_man_greater : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');
	
	signal complemented_expanded_man_smaller : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');

	signal shifted_complemented_expanded_man_smaller : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');
	signal rounding_bit : std_logic := '0';

	signal expanded_man_result : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');
	signal addition_cout : std_logic := '0';
	signal diff_signs : std_logic := '0';

	signal complemented_expanded_man_result : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');

	signal man_result : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal exp_result : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal sign_result : std_logic := '0';

	--Component used for splitting numbers to add into their scientific notations parts: mantissa, exponent, sign.
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

	--Component used to swap the inputs and recognise the bigger and the smaller to apply the adding algorithm correctly
	component number_swapper is
		generic(
			TOTAL_BITS : natural := 23;
			EXP_BITS   : natural := 6
		);

		port(
			man_1_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_1_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_2_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_2_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_greater_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			man_smaller_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_greater_out  : out std_logic_vector(EXP_BITS - 1 downto 0);
			exp_smaller_out  : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;

--Component used to expand the operands and work with double precision. It also adds the implicit 1
	component number_expander is
		generic(
			BITS : natural := 16
		);

		port(
			number_in   : in  std_logic_vector(BITS - 1 downto 0);
			number_out  : out  std_logic_vector(BITS downto 0)
		);
	end component;

 --Component used to complement the smaller mantissa to add the absolute values properly
	component sign_based_complementer is
		generic(
			BITS : natural := 16
		);

		port(
			sign_1_in   : in  std_logic;
			sign_2_in   : in  std_logic;
			man_in   : in  std_logic_vector(BITS - 1 downto 0);
			man_out : out std_logic_vector(BITS -1 downto 0)
		);
	end component;

	--Component to shift the samller mantissa in order to have the same exponents for correct addition
	component number_shifter is
		generic(
			BITS : natural := 32;
			EXP_BITS : natural := 6
		);

		port(
			sign_1_in : in std_logic;
			sign_2_in : in std_logic;
			greater_exp : in std_logic_vector(EXP_BITS - 1 downto 0);
			smaller_exp : in std_logic_vector(EXP_BITS - 1 downto 0);
			man_in  : in  std_logic_vector(BITS - 1 downto 0);
			man_out : out std_logic_vector(BITS - 1 downto 0);
			rounding_bit : out std_logic
		);
	end component;


	--Component used to add 2 expanded mantissas with the same exponents and correct the result according to sings
	component expanded_mantissa_adder is
		generic(
			BITS : natural := 16
		);

		port(
			man_1_in : in std_logic_vector(BITS - 1 downto 0);
			man_2_in : in std_logic_vector(BITS - 1 downto 0);
			result : out std_logic_vector(BITS - 1 downto 0);
			cout : out std_logic
	);
	end component;

	--Component used to complement the result in case is necessary
	component result_complementer is
		generic(
			BITS : natural := 16
		);

		port(
			in_result : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
			sign_1_in : in std_logic := '0';
			sign_2_in : in std_logic := '0';
			result_cout : in std_logic := '0';
			out_result : out std_logic_vector(BITS - 1 downto 0) := (others => '0')
		);
	end component;

	component normalizer is
		generic(
			TOTAL_BITS : natural := 23;
			EXP_BITS : natural := 6
		);

		port(
			man_in : in std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0);
			exp_in : in std_logic_vector(EXP_BITS - 1 downto 0);
			cin : in std_logic; --To check if the sum had a carry
			diff_signs : in std_logic;
			rounding_bit : in std_logic;
			man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;

	component sign_computer is

    generic(
		 BITS : natural := 16
	  );

    port(
      man_1_in: in  std_logic_vector(BITS - 1 downto 0) := (others => '0');
      man_2_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      sign_1_in: in std_logic := '0';
      sign_2_in: in std_logic := '0';
      man_greater_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      pre_complemented_result: in std_logic_vector(BITS downto 0) := (others => '0');
      complemented_result: in std_logic_vector(BITS downto 0) := (others => '0');
      sign_out: out std_logic := '0'
    );
 	end component;
	
	for sign_computer_0 : sign_computer use entity work.sign_computer;
	for normalizer_0 : normalizer use entity work.normalizer;
	for result_complementer_0 : result_complementer use entity work.result_complementer;
	for expanded_mantissa_adder_0 : expanded_mantissa_adder use entity work.expanded_mantissa_adder;
	for number_shifter_0 : number_shifter use entity work.number_shifter;
	for sign_based_complementer_0 : sign_based_complementer use entity work.sign_based_complementer;
	for number_expander_1 : number_expander use entity work.number_expander;
	for number_expander_2 : number_expander use entity work.number_expander;
	for number_swapper_0 : number_swapper use entity work.number_swapper;
	for number_splitter_1: number_splitter use entity work.number_splitter;
	for number_splitter_2: number_splitter use entity work.number_splitter;


begin

	number_splitter_1: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number_1,
			sign_out => sign_1,
			exp_out => exp_1,
			mant_out => man_1
		);

	number_splitter_2: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number_2,
			sign_out => sign_2,
			exp_out => exp_2,
			mant_out => man_2
		);

	number_swapper_0 : number_swapper
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			exp_1_in   => exp_1,
			exp_2_in   => exp_2,
			man_1_in   => man_1,
			man_2_in   => man_2,
			exp_greater_out  => exp_greater,
			exp_smaller_out => exp_smaller,
			man_greater_out  => man_greater,
			man_smaller_out  => man_smaller
	);

	number_expander_1 : number_expander
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			number_in   => man_greater,
			number_out  => expanded_man_greater
	);

	number_expander_2 : number_expander
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			number_in   => man_smaller,
			number_out  => expanded_man_smaller
	);

	sign_based_complementer_0 : sign_based_complementer
		generic map(BITS => TOTAL_BITS - EXP_BITS)
		port map(
			sign_1_in => sign_1,
			sign_2_in => sign_2,
			man_in => expanded_man_smaller,
			man_out => complemented_expanded_man_smaller
	);

	number_shifter_0 : number_shifter
		generic map(BITS => TOTAL_BITS - EXP_BITS, EXP_BITS => EXP_BITS)
		port map(
			man_in => complemented_expanded_man_smaller,
			sign_1_in => sign_1,
			sign_2_in => sign_2,
			greater_exp => exp_greater,
			smaller_exp => exp_smaller,
			man_out => shifted_complemented_expanded_man_smaller,
			rounding_bit => rounding_bit
	);

	expanded_mantissa_adder_0 : expanded_mantissa_adder
		generic map(BITS => (TOTAL_BITS - EXP_BITS))
		port map(
			man_1_in => expanded_man_greater,
			man_2_in => shifted_complemented_expanded_man_smaller,
			result => expanded_man_result,
			cout => addition_cout
		);

	result_complementer_0 : result_complementer
		generic map(BITS => (TOTAL_BITS - EXP_BITS))
		port map(
			in_result => expanded_man_result,
			sign_1_in => sign_1,
			sign_2_in => sign_2,
			result_cout => addition_cout,
			out_result => complemented_expanded_man_result
		);

	normalizer_0 : normalizer
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			man_in => complemented_expanded_man_result,
			exp_in => exp_greater,
			cin => addition_cout,
			diff_signs => diff_signs,
			rounding_bit => rounding_bit,
			man_out => man_result,
			exp_out => exp_result
	);

	sign_computer_0 : sign_computer
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			man_1_in => man_1,
			man_2_in => man_2,
			sign_1_in => sign_1,
			sign_2_in => sign_2,
			man_greater_in => man_greater,
			pre_complemented_result => expanded_man_result,
			complemented_result => complemented_expanded_man_result,
			sign_out => sign_result
	);

	process(number_1_in,
					number_2_in,
					number_1,
					number_2,
					man_1,
					man_2,
					exp_1,
					exp_2,
					sign_1,
					sign_2,
					man_greater,
					man_smaller,
					exp_greater,
					exp_smaller,
					expanded_man_smaller,
					expanded_man_greater,
					complemented_expanded_man_smaller,
					shifted_complemented_expanded_man_smaller,
					rounding_bit,
					expanded_man_result,
					complemented_expanded_man_result,
					addition_cout,
					diff_signs,
					man_result,
					exp_result,
					sign_result) is
		
	begin

	 	diff_signs <= sign_1 xor sign_2;
		number_1 <= number_1_in;
		number_2 <= number_2_in;
		result <= sign_result & exp_result & man_result;
	end process;

end;
