library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component normalizes the number so that it follows the specifications of a floating point representation

entity normalizer is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS : natural := 6
	);

	port(
		man_in : in std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0); --number enters in double precision
		exp_in : in std_logic_vector(EXP_BITS - 1 downto 0);
		cin : in std_logic; --To check if the sum had a carry
		diff_signs : in std_logic;
		rounding_bit : in std_logic;
		man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
	);

end normalizer;

architecture normalizer_arq of normalizer is
begin
	process(man_in, exp_in, cin, diff_signs, rounding_bit) is
		variable tmp_mantissa : std_logic_vector(TOTAL_BITS - EXP_BITS downto 0) := (others => '0');
		variable tmp_exp : unsigned(EXP_BITS - 1 downto 0) := (others => '0');
		variable zero_mant : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
		variable all_ones_mant : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '1');
		variable max_exp : unsigned(EXP_BITS - 1 downto 0) := (others => '1');

		variable internal_man_out : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
		variable internal_exp_out : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');
		begin
			if(cin = '1' and diff_signs = '0') then
				internal_man_out := man_in(TOTAL_BITS - EXP_BITS - 1 downto 1);

				internal_exp_out := std_logic_vector(unsigned(exp_in) + 1);
			else
				tmp_mantissa := man_in & rounding_bit;
				tmp_exp := unsigned(exp_in);
				while(tmp_mantissa(TOTAL_BITS - EXP_BITS) /= '1' and tmp_exp > 0) loop
					tmp_mantissa := std_logic_vector(shift_left(unsigned(tmp_mantissa), 1));
					tmp_exp := tmp_exp - 1;
				end loop;
				internal_man_out := tmp_mantissa((TOTAL_BITS - EXP_BITS - 1) downto 1);
				internal_exp_out := std_logic_vector(tmp_exp);
			end if;
			tmp_exp := unsigned(internal_exp_out);
			if(tmp_exp = 0) then
				man_out <= zero_mant;
				exp_out <= internal_exp_out;
			elsif (tmp_exp = max_exp) then
				man_out <= zero_mant;
				exp_out <=  std_logic_vector(max_exp);
			else
				man_out <= internal_man_out;
				exp_out <= internal_exp_out;		
			end if;
	end process;
end;
