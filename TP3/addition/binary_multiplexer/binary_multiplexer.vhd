library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_multiplexer is

    generic(
		  BITS:natural := 16
	  );

    port(
      number1_in: in  std_logic_vector(BITS-1 downto 0) := (others => '0');
      number2_in: in  std_logic_vector(BITS-1 downto 0) := (others => '0');
      chooser: in std_logic := '1';
      mux_output: out  std_logic_vector(BITS-1 downto 0) := (others => '0')
    );

end binary_multiplexer;

architecture binary_multiplexer_arq of binary_multiplexer is
    begin
        process (number1_in,number2_in,chooser) is
        begin
        	case chooser is
                when '0'  => mux_output <= number1_in;
                when '1'  => mux_output <= number2_in;
                when others => null;
            end case;
        end process;

end architecture;
