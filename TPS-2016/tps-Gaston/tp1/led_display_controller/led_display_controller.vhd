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

    a0: out std_logic;
    a1: out std_logic;
    a2: out std_logic;
    a3: out std_logic;

    a: out std_logic;
    b: out std_logic;
    c: out std_logic;
    d: out std_logic;
    e: out std_logic;
    f: out std_logic;
    g: out std_logic;
    dp: out std_logic
	);
end;

architecture led_display_controller_arq of led_display_controller is
  signal counter_enabler: std_logic:= '1';
  signal counter_output: std_logic_vector(1 downto 0);

  component generic_counter is
    generic (
      BITS:natural := 4;
      MAX_COUNT:natural := 15);
    port (
      clk: in std_logic;
      rst: in std_logic;
      ena: in std_logic;
      count: out std_logic_vector(BITS-1 downto 0);
      carry_o: out std_logic
    );
  end component;

  component generic_enabler is
  	generic(PERIOD:natural := 1000000 );
  	port(
  		clk: in std_logic;
  		rst: in std_logic;
  		ena_out: out std_logic
  	);
  end component;

begin
  genericCounterMap: generic_counter generic map (2,4)
    port map(
      clk => clk_in,
      rst => '0',
      ena => counter_enabler,
      count => counter_output
    );

    generic_enabler_map: generic_enabler generic map (100000)
    port map(
      clk => clk_in,
      rst => '0',
      ena_out => counter_enabler
    );


end;
