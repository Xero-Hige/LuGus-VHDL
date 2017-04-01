library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity number_splitter is
	generic(
		TOTAL_BITS:natural := 23;
		EXP_BITS:natural := 6);
	port (

		number_in: in std_logic_vector(TOTAL_BITS-1 downto 0);
		sign_out: out std_logic;
		exp_out: out std_logic_vector(EXP_BITS-1 downto 0);
		mant_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0)
	);
end;

architecture number_splitter_arq of number_splitter is
begin
	process(number_in)
	begin 
		sign_out <= number_in(TOTAL_BITS-1);
		exp_out <= number_in(TOTAL_BITS-2 downto TOTAL_BITS-1-EXP_BITS);
		mant_out <= number_in(TOTAL_BITS-EXP_BITS-2 downto 0);
	end process;

end architecture;