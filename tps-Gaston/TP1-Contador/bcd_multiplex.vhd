library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_multiplexer is

    port(
    bcd0_input	: in std_logic_vector(3 downto 0);
    bcd1_input	: in std_logic_vector(3 downto 0);
    bcd2_input	: in std_logic_vector(3 downto 0);
    bcd3_input	: in std_logic_vector(3 downto 0);

    mux_selector    : in std_logic_vector   (1 downto 0);
    mux_output	    : out std_logic_vector  (3 downto 0)
    );

end bcd_multiplexer;

architecture bcd_multiplexer_arq of bcd_multiplexer is
    begin
        process (bcd0_input,bcd1_input,bcd2_input,bcd3_input) is
        begin
            case mux_selector is
                when "00"   => mux_output <= bcd0_input;
                when "01"   => mux_output <= bcd1_input;
                when "10"   => mux_output <= bcd2_input;
                when "11"   => mux_output <= bcd3_input;
                when others => mux_output <= (others => '0');
            end case;
        end process;

end bcd_multiplexer_arq;
