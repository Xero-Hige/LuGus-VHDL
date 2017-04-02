library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_1_counter is

	generic (
	COUNTERS:natural := 4;
	);

    port (
    clk_in: in std_logic;
    rst_in: in std_logic;

    bcd1_out: out std_logic_vector(3 downto 0);
    clk_led_output: out std_logic_vector(7 downto 0)
    );
	
end;

architecture tp1_arq of tp1 is

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

	end;

    begin
		counters : for i in 0 to N-1 generate
		
			counter_outs: if i<3 generate
				counter_out: generic_counter
					port map(
					ck => clk ,
					rst => rst,		
					d => carry_out(i-1),
					q => d (i +1)
					);
			end generate counter_outs;
		
		
			counter_outs: if i>3 generate
				counter_out: generic_counter
					port map(
					ck => clk ,
					rst => rst,		
					d => carry_out(i-1),
					q => d (i +1)
					);
			end generate counter_outs;
			
		end generate counters;


    end;