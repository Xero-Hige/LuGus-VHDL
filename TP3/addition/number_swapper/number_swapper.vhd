library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--STEP 1
--This component takes 2 numbers written in scientific notation and returns the same 2 numbers specifying which has the biggest 
--exponent and which has the smaller

entity number_swapper is

	generic(
		TOTAL_BITS : natural := 23;
		EXP_BITS   : natural := 6
	);

	port(
		man_1_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_1_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
		man_2_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_2_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
		man_greater_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		man_smaller_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
		exp_greater_out  : out std_logic_vector(EXP_BITS - 1 downto 0);
		exp_smaller_out  : out std_logic_vector(EXP_BITS - 1 downto 0)
	);

end number_swapper;

architecture number_swapper_arq of number_swapper is

	begin
	process(man_1_in,exp_1_in,man_2_in,exp_2_in) is
		variable man_1_integer : integer := 0;
		variable man_2_integer : integer := 0;
		variable exp_1_integer : integer := 0;
		variable exp_2_integer : integer := 0;	
	begin
		man_1_integer := to_integer(unsigned(man_1_in));
		man_2_integer := to_integer(unsigned(man_2_in));
		exp_1_integer := to_integer(unsigned(exp_1_in));
		exp_2_integer := to_integer(unsigned(exp_2_in));
		if(exp_1_integer = exp_2_integer) then --compare mantissas
			if(man_1_integer > man_2_integer) then
				man_greater_out <= man_1_in;
				man_smaller_out <= man_2_in;
				exp_greater_out <= exp_1_in;
				exp_smaller_out <= exp_2_in;
			else
				man_greater_out <= man_2_in;
				man_smaller_out <= man_1_in;
				exp_greater_out <= exp_2_in;
				exp_smaller_out <= exp_1_in;
			end if;
		else
			if(exp_1_integer > exp_2_integer) then
				man_greater_out <= man_1_in;
				man_smaller_out <= man_2_in;
				exp_greater_out <= exp_1_in;
				exp_smaller_out <= exp_2_in;
			else
				man_greater_out <= man_2_in;
				man_smaller_out <= man_1_in;
				exp_greater_out <= exp_2_in;
				exp_smaller_out <= exp_1_in;
			end if;
		end if;
	end process;

end;
