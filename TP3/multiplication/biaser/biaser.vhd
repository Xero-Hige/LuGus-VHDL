library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity biaser is

	generic(
		EXP_BITS: natural := 6
	);

	port (
		operation : in std_logic; --Indicates whether to add or remove the bias
		exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
		exp_out: out std_logic_vector(EXP_BITS - 1 downto 0)
	);
end;

architecture biaser_arq of biaser is
begin
	process(operation, exp_in)
	variable bias_vector : std_logic_vector(EXP_BITS - 2 downto 0) := (others => '1');
	variable bias : integer := to_integer(unsigned(bias_vector));
	variable tmp_exp : integer := 0;
	begin
		tmp_exp := to_integer(unsigned(exp_in));
		if operation = '0' then
			exp_out <= std_logic_vector(to_signed(tmp_exp + bias, EXP_BITS));
		else
			exp_out <= std_logic_vector(to_signed(tmp_exp - bias, EXP_BITS));
		end if;
	end process;

end architecture;
