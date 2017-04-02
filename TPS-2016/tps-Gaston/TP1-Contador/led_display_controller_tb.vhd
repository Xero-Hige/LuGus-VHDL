library ieee;
use ieee.std_logic_1164.all;

entity led_display_controller_tb is
end;

architecture led_display_controller_tb_func of led_display_controller_tb is
	signal bcd0_in	:   std_logic_vector(3 downto 0);
	signal bcd1_in	:   std_logic_vector(3 downto 0);
	signal bcd2_in	:   std_logic_vector(3 downto 0);
	signal bcd3_in	:   std_logic_vector(3 downto 0);

	signal anode_out: std_logic_vector(3 downto 0);
	signal led_out	: std_logic_vector(7 downto 0);

	signal clk_in: std_logic:='0';

	component led_display_controller is

	    port (
	    clk_in: in std_logic;

	    bcd0: in std_logic_vector(3 downto 0);
	    bcd1: in std_logic_vector(3 downto 0);
	    bcd2: in std_logic_vector(3 downto 0);
	    bcd3: in std_logic_vector(3 downto 0);

	    anode_output: out std_logic_vector(3 downto 0);
	    led_output	: out std_logic_vector(7 downto 0)
	    );

	end component;

begin

	clk_in <= not(clk_in) after 1 ns;

	bcd0_in	<= b"1001";
	bcd1_in	<= b"0110";
	bcd2_in	<= b"0101";
	bcd3_in	<= b"1010";

	led_display_controllerMap: led_display_controller
	port map(
	clk_in => clk_in,

	bcd0 => bcd0_in,
	bcd1 => bcd1_in,
	bcd2 => bcd2_in,
	bcd3 => bcd3_in,

	anode_output => anode_out,
	led_output 	 => led_out
	);

end architecture;
