library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 3
--This component shifts the number so that exponents match and completes the new bits with 1's or 0's according to signs

entity number_shifter is

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
		man_out : out std_logic_vector(BITS - 1 downto 0)
	);

end number_shifter;

architecture number_shifter_arq of number_shifter is
begin
	process(sign_1_in, sign_2_in,greater_exp,smaller_exp, man_in) is
		variable shifted_number : std_logic_vector(BITS - 1 downto 0) := (others => '0');
		variable shifting_difference : integer := 0;
		variable before : integer := 0;
		variable aft : integer := 0;
		begin
			shifting_difference := to_integer(unsigned(greater_exp) - unsigned(smaller_exp));
			if (sign_1_in = sign_2_in) then
				shifted_number := std_logic_vector(shift_right(unsigned(man_in), shifting_difference));
			else
				shifted_number := std_logic_vector(shift_right(signed(man_in), shifting_difference));
			end if;
			man_out <= shifted_number;
	end process;

end;
