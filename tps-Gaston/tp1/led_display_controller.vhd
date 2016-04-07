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
  
	component bcd_mux	 IS
	port(
		bcd0_i	: IN std_logic_vector(3 DOWNTO 0); 
		bcd1_i	: IN std_logic_vector(3 DOWNTO 0); 
		bcd2_i	: IN std_logic_vector(3 DOWNTO 0); 
		bcd3_i	: IN std_logic_vector(3 DOWNTO 0); 

		m_sel	: IN std_logic_vector(1 DOWNTO 0); 
		m_out	: OUT std_logic_vector(3 DOWNTO 0));
	end component;
	
	component anode_sel	 IS
        PORT(
			 sel_in	: IN std_logic_vector(1 DOWNTO 0); 
             sel_out	: OUT std_logic_vector(3 DOWNTO 0));
     END component;
	 
	      component led_enabler	 IS
        PORT(
			 ena_in		:	IN std_logic_vector(3 DOWNTO 0); 
             ena_out	:	OUT std_logic_vector(7 DOWNTO 0));
     END component;

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
	
	bcd_muxMap: bcd_mux port map(
		bcd0_i => bcd0,
		bcd1_i => bcd1,
		bcd2_i => bcd2,
		bcd3_i => bcd3,
		m_sel => counter_output,
		m_out => multiplex_output
	);
	
	
	anode_selMap: anode_sel port map(
			 sel_in	=> counter_output, 
             sel_out	=> anode_output
	);
		
	led_enablerMap: led_enabler port map(
		
		ena_in 		=>  multiplex_output,
        ena_out	=>  led_output
		);

		
end;
