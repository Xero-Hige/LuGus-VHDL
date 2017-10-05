library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity base_complementer is

    generic(
		TOTAL_BITS : natural := 16
	  );

    port(
      number_in: in  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      number_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );

end base_complementer;

architecture base_complementer_arq of base_complementer is
    begin
    	process (number_in) is
    		variable negated_in : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
    		variable tmp_out : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
		begin
			negated_in := not number_in;
			tmp_out := std_logic_vector(unsigned(negated_in) + 1);
			number_out <= tmp_out;
        end process;

end architecture;