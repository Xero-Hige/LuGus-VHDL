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
		first_greater: in std_logic;
		second_greater: in std_logic;
		equals: in std_logic
	);
end;

architecture comparer_arq of comparer is
begin

	process(number1_in,number2_in)
		variable first_g: std_logic;
		variable second_g: std_logic;
		variable both_eq: std_logic;
		variable carry: std_logic;
	begin
		if
	end process;

end architecture;
