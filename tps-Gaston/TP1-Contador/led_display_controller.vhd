library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity led_display_controller is
    port (
    clk_in: in std_logic;

    bcd0: in std_logic_vector(3 downto 0);
    bcd1: in std_logic_vector(3 downto 0);
    bcd2: in std_logic_vector(3 downto 0);
    bcd3: in std_logic_vector(3 downto 0);

    anode_output: out std_logic_vector(3 downto 0);
    led_output: out std_logic_vector(7 downto 0)
    );
end;

architecture led_display_controller_arq of led_display_controller is
    signal counter_enabler: std_logic:= '1';
    signal counter_output: std_logic_vector(1 downto 0);
    signal multiplex_output: std_logic_vector(3 downto 0);

    component generic_counter is

        generic (
        BITS:natural := 4;
        MAX_COUNT:natural := 15
        );

        port (
        clk: in std_logic;
        rst: in std_logic;
        ena: in std_logic;
        counter_out: out std_logic_vector(BITS-1 downto 0);
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

    component bcd_multiplexer	 is

        port(
        bcd0_input	: in std_logic_vector(3 downto 0);
        bcd1_input	: in std_logic_vector(3 downto 0);
        bcd2_input	: in std_logic_vector(3 downto 0);
        bcd3_input	: in std_logic_vector(3 downto 0);

        mux_selector    : in std_logic_vector   (1 downto 0);
        mux_output	    : out std_logic_vector  (3 downto 0)
        );

        end component;

    component anode_selector	 is

        port(
        selector_in	    : in std_logic_vector   (1 downto 0);
        selector_out	: out std_logic_vector  (3 downto 0)
        );

    end component;

    component led_enabler	 is

        port(
        enabler_input   :	in    std_logic_vector(3 downto 0);
        enabler_output	:	out   std_logic_vector(7 downto 0)
        );

    end component;

begin

    generic_enablerMap: generic_counter 
    generic map (2,4)
    port map(
    clk => clk_in,
    rst => '0',
    ena => counter_enabler,
    count => counter_output
    );

    generic_enabler_map: generic_enabler
    generic map (100000)
    port map(
    clk     => clk_in,
    rst     => '0',
    ena_out => counter_enabler
    );

    bcd_multiplexerMap: bcd_mux
    port map(
    bcd0_input => bcd0,
    bcd1_input => bcd1,
    bcd2_input => bcd2,
    bcd3_input => bcd3,

    mux_selector    => counter_output,
    mux_output      => multiplex_output
    );

    anode_selMap: anode_sel
    port map(
    sel_in	=> counter_output,
    sel_out	=> anode_output
    );

    led_enablerMap: led_enabler
    port map(
    ena_in 		=>  multiplex_output,
    ena_out	=>  led_output
    );

end;
