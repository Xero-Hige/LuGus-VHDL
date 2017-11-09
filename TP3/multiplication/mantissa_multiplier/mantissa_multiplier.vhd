library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mantissa_multiplier is

	generic(
		BITS:natural := 16
	);

	port (
		man1_in: in std_logic_vector(BITS - 1 downto 0);
		man2_in: in std_logic_vector(BITS - 1 downto 0);
		result: out std_logic_vector(BITS downto 0) --Add one to shift if necessary
	);
end;

architecture mantissa_multiplier_arq of mantissa_multiplier is
begin
	process(man1_in, man2_in)
	variable tmp_result: std_logic_vector(BITS*2 - 1 downto 0) := (others => '0');
	begin
		tmp_result := std_logic_vector(unsigned(man1_in) * unsigned(man2_in));
		result <= tmp_result(BITS*2 - 1 downto BITS - 1);
	end process;

end architecture;
