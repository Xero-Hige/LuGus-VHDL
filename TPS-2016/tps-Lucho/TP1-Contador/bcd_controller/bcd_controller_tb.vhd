library ieee;
use ieee.std_logic_1164.all;

entity bcd_controller_tb is
end;

architecture bcd_controller_tb_func of bcd_controller_tb is
	signal clk_in: std_logic:='0';
	signal anod_out: std_logic_vector(3 downto 0);
	signal a: std_logic;
	signal b: std_logic;
	signal c: std_logic;
	signal d: std_logic;
	signal e: std_logic;
	signal f: std_logic;
	signal g: std_logic;
	signal dp: std_logic;
	
	
	component bcd_controller is

		port(
			clk: in std_logic;
			anod_out: out std_logic_vector(3 downto 0);
			a: out std_logic;
			b: out std_logic;
			c: out std_logic;
			d: out std_logic;
			e: out std_logic;
			f: out std_logic;
			g: out std_logic;
			dp: out std_logic
		
		);
	end component;

begin

	clk_in <= not(clk_in) after 20 ns;
	
	
	bcd_controllerMap: bcd_controller
		port map(
			clk => clk_in,
			anod_out => anod_out,
			a => a,
			b => b,
			c => c,
			d => d,
			e => e,
			f => f,
			g => g,
			dp => dp
		);
		
end architecture;		

