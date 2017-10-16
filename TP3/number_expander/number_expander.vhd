library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 2.5
--This component expands the number so that we can work and operate with double precision. 
--It also adds the implicit 1 in the most significant bit

entity number_expander is

	generic(
		BITS : natural := 16
	);

	port(
		number_in  : in  std_logic_vector(BITS - 1 downto 0);
		number_out : out std_logic_vector(BITS*2 - 1 downto 0)
	);

end number_expander;

architecture number_expander_arq of number_expander is
begin
	process(number_in) is
		variable double_precision_number : std_logic_vector(BITS * 2 - 1 downto 0) := (others => '0');
		begin
			double_precision_number(BITS * 2 - 1) := '1'; --implicit 1
			double_precision_number(BITS * 2 - 2 downto BITS - 1) := number_in;
			number_out <= double_precision_number;
	end process;

end;
