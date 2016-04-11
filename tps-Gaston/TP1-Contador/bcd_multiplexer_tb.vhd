library ieee;
use ieee.std_logic_1164.all;

entity bcd_multiplexer_tb is
end;

architecture bcd_multiplexer_tb_func of bcd_multiplexer_tb is
	signal bcd0_in	:   std_logic_vector(3 downto 0);
	signal bcd1_in	:   std_logic_vector(3 downto 0);
	signal bcd2_in	:   std_logic_vector(3 downto 0);
	signal bcd3_in	:   std_logic_vector(3 downto 0);

	signal signal_in_a 	: std_logic:='0';
	signal signal_in_b 	: std_logic:='0';
	signal selector_in  : std_logic_vector (1 downto 0);

	signal mux_out: std_logic_vector(3 downto 0);

	component bcd_multiplexer is

	    port(
	    bcd0_input	: in std_logic_vector(3 downto 0);
	    bcd1_input	: in std_logic_vector(3 downto 0);
	    bcd2_input	: in std_logic_vector(3 downto 0);
	    bcd3_input	: in std_logic_vector(3 downto 0);

	    mux_selector    : in std_logic_vector   (1 downto 0);
	    mux_output	    : out std_logic_vector  (3 downto 0)
	    );

	end component;

begin

	bcd0_in	<= b"0001";
	bcd1_in	<= b"0010";
	bcd2_in	<= b"0100";
	bcd3_in	<= b"1000";

	signal_in_a    	<= not signal_in_a after 10 ns;
    signal_in_b    	<= not signal_in_b after 20 ns;
    selector_in(0)  <= signal_in_a;
    selector_in(1)  <= signal_in_b;

	bcd_multiplexerMap: bcd_multiplexer
	port map(
	bcd0_input => bcd0_in,
	bcd1_input => bcd1_in,
	bcd2_input => bcd2_in,
	bcd3_input => bcd3_in,

	mux_selector => selector_in,
	mux_output => mux_out
	);

end architecture;
