library ieee;
use ieee.std_logic_1164.all;

entity led_enabler_tb is
end;

architecture led_enabler_tb_func of led_enabler_tb is
	signal signal_in_a 	: std_logic:='0';
	signal signal_in_b 	: std_logic:='0';
	signal signal_in_c 	: std_logic:='0';
	signal signal_in_d 	: std_logic:='0';
	signal enabler_in   : std_logic_vector (3 downto 0);

	signal enabler_out	: std_logic_vector(7 downto 0);

	component led_enabler	 is

	    port(
	    enabler_input   :	in    std_logic_vector(3 downto 0);
	    enabler_output	:	out   std_logic_vector(7 downto 0)
	    );

	end component;

begin
	signal_in_a	<= not signal_in_a after 10 ns;
	signal_in_b	<= not signal_in_b after 20 ns;
	signal_in_c	<= not signal_in_c after 40 ns;
	signal_in_d	<= not signal_in_d after 80 ns;
	enabler_in(0)	<= signal_in_a;
	enabler_in(1)   <= signal_in_b;
	enabler_in(2)   <= signal_in_c;
	enabler_in(3)   <= signal_in_d;

	led_enablerMap: led_enabler
	port map(
	enabler_input  => enabler_in,
	enabler_output => enabler_out
	);

end architecture;
