library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_enabler	 is

    port(
    enabler_input   :	in    std_logic_vector(3 downto 0);
    enabler_output  :	out   std_logic_vector(7 downto 0)
    );

end led_enabler;

architecture led_enabler_arq of led_enabler is
    begin
        process (enabler_input) is
        begin
            case enabler_input is
                when "0000" => enabler_output  <= not b"11111100"; ---a->g
                when "0001" => enabler_output  <= not b"01100000";
                when "0010" => enabler_output  <= not b"11011010";
                when "0011" => enabler_output  <= not b"11110010";
                when "0100" => enabler_output  <= not b"01100110";
                when "0101" => enabler_output  <= not b"10110110";
                when "0110" => enabler_output  <= not b"10111110";
                when "0111" => enabler_output  <= not b"11100000";
                when "1000" => enabler_output  <= not b"11111110";
                when "1001" => enabler_output  <= not b"11100110";
                when others => enabler_output  <= not b"01111100"; ---u
            end case;
        end process;
end led_enabler_arq;
