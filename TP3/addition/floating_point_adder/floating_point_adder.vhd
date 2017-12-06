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
		enable : in std_logic;
		reset : in std_logic;
		clk : in std_logic;
		number_1_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		number_2_in : in std_logic_vector(TOTAL_BITS - 1 downto 0);
		result: out std_logic_vector(TOTAL_BITS - 1 downto 0)
	);
end floating_point_adder;

architecture floating_point_adder_arq of floating_point_adder is

	signal enable_in : std_logic := '0';
	signal reset_in : std_logic := '0';
	signal clk_in : std_logic := '0';

	signal number_1 :  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
	signal number_2 :  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');

	--For registry shared values: 
	-- br = before registry
	-- ar = after registry

	signal man_1_br : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0'); 
	signal man_1_ar : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0'); 
	
	signal man_2_br : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal man_2_ar : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	
	signal exp_1_br : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_1_ar : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	
	signal exp_2_br : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_2_ar : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	
	signal sign_1_br : std_logic := '0';
	signal sign_1_ar : std_logic := '0';
	
	signal sign_2_br : std_logic := '0';
	signal sign_2_ar : std_logic := '0';

	signal man_greater_br : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal man_greater_ar : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	
	signal man_smaller_br : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	signal man_smaller_ar : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	
	signal exp_greater_br : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_greater_ar : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	
	signal exp_smaller_br : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
	signal exp_smaller_ar : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

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


	--Component for storing intermediate values
	component registry is
		generic(TOTAL_BITS : integer := 32);
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			D: in std_logic_vector(TOTAL_BITS - 1 downto 0);
			Q: out std_logic_vector(TOTAL_BITS - 1 downto 0)
		);
	end component;

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
	

 	--Registries
 	for step1_mantissa_1 : registry use entity work.registry;
 	for step1_mantissa_2 : registry use entity work.registry;
 	for step1_exponent_1 : registry use entity work.registry;
 	for step1_exponent_2 : registry use entity work.registry;
 	for step1_sign_1 : registry use entity work.registry;
 	for step1_sign_2 : registry use entity work.registry;

 	for step2_mantissa_greater : registry use entity work.registry;
 	for step2_mantissa_smaller : registry use entity work.registry;
 	for step2_exponent_greater : registry use entity work.registry;
 	for step2_exponent_smaller : registry use entity work.registry;
 	for step2_sign_1 : registry use entity work.registry;
 	for step2_sign_2 : registry use entity work.registry;


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

	--########################## STEP 1 #################################

	number_splitter_1: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number_1,
			sign_out => sign_1_br,
			exp_out => exp_1_br,
			mant_out => man_1_br
		);

	number_splitter_2: number_splitter 
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			number_in => number_2,
			sign_out => sign_2_br,
			exp_out => exp_2_br,
			mant_out => man_2_br
		);

	step1_mantissa_1 : registry
		generic map(TOTAL_BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => man_1_br,
			Q => man_1_ar
	);


	step1_mantissa_2 : registry
		generic map(TOTAL_BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => man_2_br,
			Q => man_2_ar
	);

	step1_exponent_1 : registry
		generic map(TOTAL_BITS => EXP_BITS)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => exp_1_br,
			Q => exp_1_ar
	);

	step1_exponent_2 : registry
		generic map(TOTAL_BITS => EXP_BITS)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => exp_2_br,
			Q => exp_2_ar
	);

	step1_sign_1 : registry
		generic map(TOTAL_BITS => 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D(0) => sign_1_br, --one is vector the other is std_logic
			Q(0) => sign_1_ar --one is vector the other is std_logic
	);

	step1_sign_2 : registry
		generic map(TOTAL_BITS => 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D(0) => sign_2_br, --one is vector the other is std_logic
			Q(0) => sign_2_ar --one is vector the other is std_logic
	);

	--##################### STEP 2 ##########################

	number_swapper_0 : number_swapper
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			exp_1_in   => exp_1_ar,
			exp_2_in   => exp_2_ar,
			man_1_in   => man_1_ar,
			man_2_in   => man_2_ar,
			exp_greater_out  => exp_greater_br,
			exp_smaller_out => exp_smaller_br,
			man_greater_out  => man_greater_br,
			man_smaller_out  => man_smaller_br
	);

	step2_mantissa_greater : registry
		generic map(TOTAL_BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => man_greater_br,
			Q => man_greater_ar
	);


	step2_mantissa_smaller : registry
		generic map(TOTAL_BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => man_smaller_br,
			Q => man_smaller_ar
	);

	step2_exponent_greater : registry
		generic map(TOTAL_BITS => EXP_BITS)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => exp_greater_br,
			Q => exp_greater_ar
	);

	step2_exponent_smaller : registry
		generic map(TOTAL_BITS => EXP_BITS)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D => exp_smaller_br,
			Q => exp_smaller_ar
	);

	step2_sign_1 : registry
		generic map(TOTAL_BITS => 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D(0) => sign_1_br, --one is vector the other is std_logic
			Q(0) => sign_1_ar --one is vector the other is std_logic
	);

	step2_sign_2 : registry
		generic map(TOTAL_BITS => 1)
		port map(
			enable => enable_in,
			reset => reset_in,
			clk => clk_in,
			D(0) => sign_2_br, --one is vector the other is std_logic
			Q(0) => sign_2_ar --one is vector the other is std_logic
	);




	number_expander_1 : number_expander
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			number_in   => man_greater_ar,
			number_out  => expanded_man_greater
	);

	number_expander_2 : number_expander
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			number_in   => man_smaller_ar,
			number_out  => expanded_man_smaller
	);

	sign_based_complementer_0 : sign_based_complementer
		generic map(BITS => TOTAL_BITS - EXP_BITS)
		port map(
			sign_1_in => sign_1_ar,
			sign_2_in => sign_2_ar,
			man_in => expanded_man_smaller,
			man_out => complemented_expanded_man_smaller
	);

	number_shifter_0 : number_shifter
		generic map(BITS => TOTAL_BITS - EXP_BITS, EXP_BITS => EXP_BITS)
		port map(
			man_in => complemented_expanded_man_smaller,
			sign_1_in => sign_1_ar,
			sign_2_in => sign_2_ar,
			greater_exp => exp_greater_ar,
			smaller_exp => exp_smaller_ar,
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
			sign_1_in => sign_1_ar,
			sign_2_in => sign_2_ar,
			result_cout => addition_cout,
			out_result => complemented_expanded_man_result
		);

	normalizer_0 : normalizer
		generic map(TOTAL_BITS => TOTAL_BITS, EXP_BITS => EXP_BITS)
		port map(
			man_in => complemented_expanded_man_result,
			exp_in => exp_greater_ar,
			cin => addition_cout,
			diff_signs => diff_signs,
			rounding_bit => rounding_bit,
			man_out => man_result,
			exp_out => exp_result
	);

	sign_computer_0 : sign_computer
		generic map(BITS => TOTAL_BITS - EXP_BITS - 1)
		port map(
			man_1_in => man_1_ar,
			man_2_in => man_2_ar,
			sign_1_in => sign_1_ar,
			sign_2_in => sign_2_ar,
			man_greater_in => man_greater_ar,
			pre_complemented_result => expanded_man_result,
			complemented_result => complemented_expanded_man_result,
			sign_out => sign_result
	);

	process(clk,
					enable,
					reset,
					number_1_in,
					number_2_in,
					number_1,
					number_2,
					man_1_ar,
					man_2_ar,
					exp_1_ar,
					exp_2_ar,
					sign_1_ar,
					sign_2_ar,
					man_greater_ar,
					man_smaller_ar,
					exp_greater_ar,
					exp_smaller_ar,
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

		enable_in <= enable;
		reset_in	<= reset;
		clk_in <= clk;

	 	diff_signs <= sign_1_ar xor sign_2_ar;
		number_1 <= number_1_in;
		number_2 <= number_2_in;
		result <= sign_result & exp_result & man_result;
	end process;

end;
