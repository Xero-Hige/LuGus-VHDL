library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity anode_selector	 is

    port(
    selector_in	    : in std_logic_vector   (1 downto 0);
    selector_out	: out std_logic_vector  (3 downto 0)
    );

end anode_selector;

architecture anode_selector_arq of anode_selector is
    begin
        process (selector_in) is
        begin
            case selector_in is
                when "00"   => selector_out <= not  b"0001";
                when "01"   => selector_out <= not  b"0010";
                when "10"   => selector_out <= not  b"0100";
                when "11"   => selector_out <= not  b"1000";
                when others => selector_out <= (others => '0');
            end case;
        end process;
end anode_selector_arq;
