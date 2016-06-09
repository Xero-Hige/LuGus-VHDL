library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_multiplexer is

    port(
    bcd0_input	: in std_logic_vector(3 downto 0);
    bcd1_input	: in std_logic_vector(3 downto 0);
    bcd2_input	: in std_logic_vector(3 downto 0);
    bcd3_input	: in std_logic_vector(3 downto 0);
	bcd4_input	: in std_logic_vector(3 downto 0);
    bcd5_input	: in std_logic_vector(3 downto 0);
   

    mux_selector    : in  std_logic_vector  (2 downto 0);
    mux_output      : out std_logic_vector  (5	downto 0)
    );

end bcd_multiplexer;

architecture bcd_multiplexer_arq of bcd_multiplexer is
    begin
        process (mux_selector,bcd0_input,bcd1_input,bcd2_input,bcd3_input,bcd4_input,bcd5_input) is
        begin
            case mux_selector is
                when "000"   => mux_output <= "00"&bcd0_input;
                when "001"   => mux_output <= "00"&bcd1_input;
                when "010"   => mux_output <= "00"&bcd2_input;
                when "011"   => mux_output <= "00"&bcd3_input;
				when "100"   => mux_output <= "00"&bcd4_input;
                --when "101"   => mux_output <= "00"&bcd5_input;
                when others  => mux_output <= "00"&bcd5_input;
            end case;
        end process;

end bcd_multiplexer_arq;