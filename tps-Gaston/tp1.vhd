library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity tp1 is
  port (
		clk_in: in std_logic;
		rst_in: in std_logic;
		
		clk_anode_ouput: out std_logic_vector(3 downto 0);
		clk_led_output: out std_logic_vector(7 downto 0)
	);
end;

architecture tp1_arq of tp1 is

signal enabler_output : std_logic := '0';
signal bcd0_out : std_logic_vector(3 downto 0) := (others => '0');
signal bcd1_out : std_logic_vector(3 downto 0) := (others => '0');
signal bcd2_out : std_logic_vector(3 downto 0) := (others => '0');
signal bcd3_out : std_logic_vector(3 downto 0) := (others => '0');

signal co_bcd0 :  std_logic := '0';
signal co_bcd1 :  std_logic := '0';
signal co_bcd2 :  std_logic := '0';
signal co_bcd3 :  std_logic := '0';



component led_display_controller is
  port (
		clk_in: in std_logic;

    bcd0: in std_logic_vector(3 downto 0);
    bcd1: in std_logic_vector(3 downto 0);
    bcd2: in std_logic_vector(3 downto 0);
    bcd3: in std_logic_vector(3 downto 0);

    anode_output: out std_logic_vector(3 downto 0);
	led_output: out std_logic_vector(7 downto 0)
	);
end component;

component cont_bcd is
	port (
		clk: in std_logic;
		rst: in std_logic;
		ena: in std_logic;
		s: out std_logic_vector(3 downto 0);
		co: out std_logic
	);
end component;

component generic_enabler is
	generic(PERIOD:natural := 1000000 ); --1MHz
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena_out: out std_logic
	);
end component;

begin

	generic_enablerMap: generic_enabler generic map(10000)
	port map (
	clk => clk_in,
	rst => rst_in,
	ena_out => enabler_output
	);
	
	cont_bcd0Map: cont_bcd port map(
		clk => clk_in,
		rst => rst_in,
		ena => enabler_output,
		s => bcd0_out,
		co => co_bcd0
	);	
	
	cont_bcd1Map: cont_bcd port map(
		clk => clk_in,
		rst => rst_in,
		ena => co_bcd0,
		s => bcd1_out,
		co => co_bcd1
	);	
	
	cont_bcd2Map: cont_bcd port map(
		clk => clk_in,
		rst => rst_in,
		ena => co_bcd1,
		s => bcd2_out,
		co => co_bcd2
	);	
	
	cont_bcd3Map: cont_bcd port map(
		clk => clk_in,
		rst => rst_in,
		ena => co_bcd2,
		s => bcd3_out,
		co => co_bcd3
	);	
	
	
	led_display_controllerMap: led_display_controller   port map (
	clk_in => clk_in,

    bcd0 => bcd0_out,
    bcd1 => bcd1_out,
    bcd2 => bcd2_out,
    bcd3 => bcd3_out,

    anode_output => clk_anode_ouput,
	led_output => clk_led_output
	);
	
end;
