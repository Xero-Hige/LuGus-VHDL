library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utility.all;

entity voltage_registry_enabler is

    port (
		clk_in: in std_logic;
		rst_in: in std_logic;
		ena_in: in std_logic;
		out_1: out std_logic;
		out_2: out std_logic
    );
	
end;

architecture voltage_registry_enabler_arq of voltage_registry_enabler is

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

	signal reset_1_counter : std_logic := '0';
	
    begin
		
		
		cycle_counter1: generic_counter
			generic map(16,33300)
				port map(
					clk => clk_in,
					rst => rst_in,
					ena => ena_in,
					carry_out => out_1
				);
				
		
		cycle_counter2: generic_counter
			generic map(16,33301)
				port map(
					clk => clk_in,
					rst => rst_in,
					ena => ena_in,
					carry_out => out_2
				);
				


    end;