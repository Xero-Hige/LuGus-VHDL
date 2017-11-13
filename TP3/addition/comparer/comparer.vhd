library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparer is

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
end;

architecture comparer_arq of comparer is
begin

	process(number1_in,number2_in)
		variable first_g: std_logic := '0';
		variable second_g: std_logic := '0';
		variable both_eq: std_logic := '0';
		variable first: unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
		variable second: unsigned(BITS-1 downto 0) := to_unsigned(0, BITS);
	begin
		first_g 	:= '0';
		second_g 	:= '0';
		both_eq 	:= '0';
		first := unsigned(number1_in);
		second := unsigned(number2_in);

		if first > second then
			first_g := '1';
		elsif first < second then
			second_g := '1';
		else
			both_eq := '1';
		end if;

		first_greater <= first_g;
		second_greater <= second_g;
		equals <= both_eq;
	end process;

end architecture;