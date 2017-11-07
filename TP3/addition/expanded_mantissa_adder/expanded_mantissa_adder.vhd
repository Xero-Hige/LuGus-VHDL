library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 4
--This component takes 2 mantissas that were already equalized and adds them

entity expanded_mantissa_adder is

	generic(
		BITS : natural := 16
	);

	port(
		man_1_in : in std_logic_vector(BITS - 1 downto 0);
		man_2_in : in std_logic_vector(BITS - 1 downto 0);
		result : out std_logic_vector(BITS - 1 downto 0);
		cout : out std_logic
	);
end expanded_mantissa_adder;

architecture expanded_mantissa_adder_arq of expanded_mantissa_adder is

	signal sum_result : std_logic_vector(BITS - 1 downto 0) := (others => '0');
	signal result_carry : std_logic := '0';

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

	for adder_0 : class_adder use entity work.class_adder;

begin

	adder_0 : class_adder
		generic map(N => BITS)
		port map(
			number1_in  => man_1_in,
			number2_in => man_2_in,
			cin     => '0',
			result  => sum_result,
			cout => result_carry
		);

	process(man_1_in,man_2_in,sum_result,result_carry) is
		
	begin
		result <= sum_result;
		cout <= result_carry;
		
	end process;

end architecture;
