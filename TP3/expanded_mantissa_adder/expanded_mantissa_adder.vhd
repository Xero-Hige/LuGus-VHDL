library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 4
--This component takes 2 mantissas that were already equalized and adds them, correcting the result according to the signs

entity expanded_mantissa_adder is

	generic(
		BITS : natural := 16
	);

	port(
		man_1_in : in std_logic_vector(BITS - 1 downto 0);
		man_2_in : in std_logic_vector(BITS - 1 downto 0);
		sign_1_in : in std_logic;
		sign_2_in : in std_logic;
		result : out std_logic_vector(BITS - 1 downto 0)
	);
end expanded_mantissa_adder;

architecture expanded_mantissa_adder_arq of expanded_mantissa_adder is

	signal sum_result : std_logic_vector(BITS - 1 downto 0) := (others => '0');
	signal complemented_result : std_logic_vector(BITS -1 downto 0) := (others => '0');
	signal cout : std_logic := '1';

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

	component base_complementer is
		generic(
			TOTAL_BITS : natural := 16
	  );

    port(
      number_in: in  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      number_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
  end component;

	for adder_0 : class_adder use entity work.class_adder;
	for base_complementer_0 : base_complementer use entity work.base_complementer;

begin

	adder_0 : class_adder
		generic map(N => BITS)
		port map(
			number1_in  => man_1_in,
			number2_in => man_2_in,
			cin     => '0',
			result  => sum_result,
			cout => cout
		);

	base_complementer_0 : base_complementer
		generic map(TOTAL_BITS => BITS)
		port map (
			number_in => sum_result,
			number_out => complemented_result
		);

	process(man_1_in,man_2_in,sign_1_in,sign_2_in,sum_result,cout, complemented_result) is
		
	begin
		if((sign_1_in /= sign_2_in) and (cout = '0') and	(sum_result(BITS - 1) = '1')) then
			result <= complemented_result;
		else
		 	result <= sum_result;
		end if; 
		
	end process;

end architecture;
