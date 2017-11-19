library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 2
--This component takes the signs of the 2 numbers to operate with and returns the base complement of the mantissa received
--if the signs are different.

entity sign_based_complementer is

	generic(
		BITS : natural := 16
	);

	port(
		sign_1_in   : in  std_logic;
		sign_2_in   : in  std_logic;
		man_in   : in  std_logic_vector(BITS - 1 downto 0);
		man_out : out std_logic_vector(BITS - 1 downto 0)
	);

end sign_based_complementer;

architecture sign_based_complementer_arq of sign_based_complementer is
	
	signal complemented_mantissa : std_logic_vector(BITS - 1 downto 0) := (others => '0');

	component base_complementer is
		generic(
			TOTAL_BITS : natural := 16
	  );

    port(
      number_in: in  std_logic_vector(TOTAL_BITS - 1 downto 0);
      number_out: out std_logic_vector(TOTAL_BITS - 1 downto 0)
    );

	end component;

	for base_complementer_0 : base_complementer use entity work.base_complementer;

	begin

		base_complementer_0 : base_complementer
		generic map(TOTAL_BITS => BITS)
		port map(
			number_in  => man_in,
			number_out => complemented_mantissa
		);

	process(sign_1_in, sign_2_in, man_in, complemented_mantissa) is
		begin
			if (sign_1_in /= sign_2_in) then
				man_out <= complemented_mantissa;
			else 
				man_out <= man_in;
			end if;

	end process;

end;
