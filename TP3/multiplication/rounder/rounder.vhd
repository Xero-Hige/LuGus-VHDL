library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rounder is

	generic(
		TOTAL_BITS:natural := 23;
		EXP_BITS: natural := 6
	);

	port (
		man_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 1 downto 0);
		exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
		man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
	);
end;

architecture rounder_arq of rounder is
begin
	process(man_in, exp_in)
	variable tmp_exp : integer := 0;
	begin
		tmp_exp := to_integer(unsigned(exp_in)) + 1;
		if man_in(TOTAL_BITS - EXP_BITS - 1) = '1' then
			exp_out <= std_logic_vector(to_unsigned(tmp_exp, EXP_BITS));
			man_out <= man_in(TOTAL_BITS - EXP_BITS - 1 downto 1);
		else
			exp_out <= exp_in;
			man_out <= man_in(TOTAL_BITS - EXP_BITS - 2 downto 0);
		end if;
	end process;

end architecture;
