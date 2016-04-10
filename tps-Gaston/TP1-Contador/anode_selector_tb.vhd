library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity anode_selector_tb	 is
end;

architecture anode_selector_func of anode_selector_tb is
    signal signal_in_a : std_logic:='0';
    signal signal_in_b : std_logic:='0';
    signal signal_in   : std_logic_vector (1 downto 0);
	signal signal_out  : std_logic_vector (3 downto 0);

	component anode_selector	 is

        port(
        selector_in	    : in  std_logic_vector  (1 downto 0);
        selector_out	: out std_logic_vector  (3 downto 0)
        );

	end component;

begin

	signal_in_a    <= not signal_in_a after 10 ns;
    signal_in_b    <= not signal_in_b after 20 ns;
    signal_in(0)   <= signal_in_a;
    signal_in(1)   <= signal_in_b;

	anode_selectorMap: anode_selector
    port map(
    selector_in     => signal_in,
    selector_out    => signal_out
    );

end anode_selector_func;
