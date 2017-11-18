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
		man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
	);

end normalizer;

architecture normalizer_arq of normalizer is
begin
	process(man_in, exp_in, cin) is
		variable tmp_mantissa : std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0) := (others => '0');
		variable tmp_exp : unsigned(EXP_BITS - 1 downto 0) := (others => '0');
		begin
			if(cin = '1' and diff_signs = '0') then
				man_out <= man_in(TOTAL_BITS - EXP_BITS - 2 downto 0);
				exp_out <= std_logic_vector(unsigned(exp_in) + 1);
			else
				tmp_mantissa := man_in;
				tmp_exp := unsigned(exp_in);
				while(tmp_mantissa(TOTAL_BITS - EXP_BITS - 1) /= '1' and tmp_exp > 0) loop
					tmp_mantissa := std_logic_vector(shift_left(unsigned(tmp_mantissa), 1));
					tmp_exp := tmp_exp - 1;
				end loop;
				man_out <= tmp_mantissa((TOTAL_BITS - EXP_BITS - 2) downto 0);
				exp_out <= std_logic_vector(tmp_exp);
			end if;
	end process;
end;
