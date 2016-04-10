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

    attribute loc: string;

    attribute loc of clk_in:	signal is "B8";
    attribute loc of rst_in:	signal is "B18";
    attribute loc of clk_anode_ouput:	signal is "F15 C18 H17 F17";
    attribute loc of clk_led_output:	signal is "L18 F18 D17 D16 G14 J17 H14 C17";

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

    signal bcd1_en : std_logic := '0';
    signal bcd2_en : std_logic := '0';
    signal bcd3_en : std_logic := '0';


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

    component  bcd_counter is

    	port (
    	clk: in std_logic;
    	rst: in std_logic;
    	ena: in std_logic;
    	counter_out: out std_logic_vector(3 downto 0);
    	carry_out: out std_logic
    	);

    end component;

    component generic_enabler is

    	generic(
    	PERIOD:natural := 1000000 --1MHz
    	);

    	port(
    	clk: in std_logic;
    	rst: in std_logic;
    	enabler_out: out std_logic
    	);

    end component;

    begin

        bcd1_en  <=  co_bcd0 and enabler_output;
        bcd2_en  <=  co_bcd1 and bcd1_en;
        bcd3_en  <=  co_bcd2 and bcd2_en;

        generic_enablerMap: generic_enabler
        generic map(5000000)
        port map (
        clk => clk_in,
        rst => '0',
        enabler_out => enabler_output
        );

        bcd_counter0Map: bcd_counter
        port map(
        clk => clk_in,
        rst => rst_in,
        ena => enabler_output,
        counter_out => bcd0_out,
        carry_out => co_bcd0
        );

        bcd_counter1Map: bcd_counter
        port map(
        clk => clk_in,
        rst => rst_in,
        ena => bcd1_en,
        counter_out => bcd1_out,
        carry_out => co_bcd1
        );

        bcd_counter2Map: bcd_counter
        port map(
        clk => clk_in,
        rst => rst_in,
        ena => bcd2_en,
        counter_out => bcd2_out,
        carry_out => co_bcd2
        );

        bcd_counter3Map: bcd_counter
        port map(
        clk => clk_in,
        rst => rst_in,
        ena => bcd3_en,
        counter_out => bcd3_out,
        carry_out => co_bcd3
        );


        led_display_controllerMap: led_display_controller
        port map (
        clk_in => clk_in,

        bcd0 => bcd0_out,
        bcd1 => bcd1_out,
        bcd2 => bcd2_out,
        bcd3 => bcd3_out,

        anode_output => clk_anode_ouput,
        led_output => clk_led_output
        );

    end;
