library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utility.all;

entity bcd_1_counter is

	generic (
	COUNTERS:natural := 5;
	OUTPUT:natural := 3
	);

    port (
    clk_in: in std_logic;
    rst_in: in std_logic;
	ena_in: in std_logic;
    counter_out: out bcd_vector (OUTPUT-1 downto 0)
    );
	
end;

architecture bcd_1_counter_arq of bcd_1_counter is

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

	
	signal bcd_ena_input : signal_vector(0 to COUNTERS) := (others => '1'); --Un valor mas que la cantidad de contadores
	signal bcd_cout : signal_vector(COUNTERS downto 0) := (others => '1'); --Un valor mas que la cantidad de contadores	
	
    begin
	
		bcd_ena_input(0) <= ena_in;
	
		bcd_counters : for i in 1 to COUNTERS generate
			
			bcd_ena_input(i) <= bcd_ena_input(i-1) AND bcd_cout(i-1);
			
			counter_outs_valid: if i>COUNTERS-OUTPUT generate
				counter_out_valid: generic_counter
					generic map(4,9)
					port map(
						clk => clk_in,
						rst => rst_in,
						ena => bcd_ena_input(i),
						counter_out => counter_out(i-1 - COUNTERS + OUTPUT), --Para darlos vuelta y tomar solo los mas significativos
						carry_out => bcd_cout(i)
					);
				
			end generate counter_outs_valid;
		
		
			counter_outs_not_valid : if i < COUNTERS-OUTPUT+1 generate
				counter_out_not_valid: generic_counter
					generic map(4,9)
					port map(
						clk => clk_in,
						rst => rst_in,
						ena => bcd_ena_input(i),
						--counter_out => counter_out(-i + COUNTERS),
						carry_out => bcd_cout(i)
					);
			end generate counter_outs_not_valid;
			
			
		end generate bcd_counters;


    end;