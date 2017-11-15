library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rounder is

	generic(
		TOTAL_BITS:natural := 23;
		EXP_BITS: natural := 6
	);

	port (
		exponent_addition_cout: in std_logic;
		man_in: in std_logic_vector(TOTAL_BITS - EXP_BITS downto 0);
		exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
		man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
	);
end;

architecture rounder_arq of rounder is
begin
	process(man_in, exp_in, exponent_addition_cout)
	variable tmp_exp : integer := 0;
	variable bias_vector : std_logic_vector(EXP_BITS - 2 downto 0) := (others => '1');
	variable bias : integer := 0;
	variable extended_exponent : std_logic_vector(EXP_BITS downto 0) := (others => '0');

	variable zero_man : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	variable zero_exp : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '0');

	variable infinity_man : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '1');
	variable infinity_exp : std_logic_vector(EXP_BITS - 2 downto 0) := (others => '1');

	variable max_exp_vector : std_logic_vector(EXP_BITS - 1 downto 0) := (others => '1');
	variable max_exp : integer := 0;

	variable out_man : std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0) := (others => '0');
	
	begin
		extended_exponent := exponent_addition_cout & exp_in;
		tmp_exp := to_integer(unsigned(extended_exponent));
		bias := to_integer(unsigned('0' & bias_vector));
		tmp_exp := tmp_exp - bias;
		max_exp := to_integer(unsigned(max_exp_vector));

		--Check if the exponent needs to be modified and the mantissa shifted
		if(man_in(TOTAL_BITS - EXP_BITS) = '1') then
			out_man := man_in(TOTAL_BITS - EXP_BITS - 1 downto 1);
			tmp_exp := tmp_exp + 1;
		else
			out_man := man_in(TOTAL_BITS - EXP_BITS - 2 downto 0);
		end if;

		if(tmp_exp <= 0) then --round to 0
			exp_out <= zero_exp;
			man_out <= zero_man;
		elsif(tmp_exp >= max_exp) then --round to infinity
			exp_out <= infinity_exp & '0';
			man_out <= infinity_man;
		else
			exp_out <= std_logic_vector(to_unsigned(tmp_exp, EXP_BITS));
			man_out <= out_man;
		end if;
	end process;

end architecture;
