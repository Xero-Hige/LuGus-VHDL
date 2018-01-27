library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity enable_generator is
	generic(CYCLE_COUNT: integer := 10; PASSIVE_CYCLES: integer := 0; ACTIVE_CYCLES: integer := 0);
	port(
		rst : in std_logic := '0';
		clk: in std_logic := '0';
		enable_in: in std_logic := '0';
		enable_out : out std_logic := '0'
	);
end entity;

architecture enable_generator_arq of enable_generator is
	signal passive : integer := 0;
	signal active : integer := 0;
	signal counted : integer := 0; 

begin
	
	process(clk, rst)
		variable passive_count : integer := 0;
		variable active_count : integer := 0;
		variable counted_cycles : integer := 0;
	begin
		if(rst = '1') then
			passive_count := 0;
			active_count := 0;
			counted_cycles := 0;
			enable_out <= '0';
		elsif(enable_in = '1') then
			if(rising_edge(clk)) then
				if(counted_cycles = CYCLE_COUNT - 1) then
					if(passive_count = PASSIVE_CYCLES - 1) then
						if(active_count = ACTIVE_CYCLES) then
							active_count := 0;
							passive_count := 0;
						else
							active_count := active_count + 1;
							enable_out <= '1';
						end if;
					else
						passive_count := passive_count + 1;
						enable_out <= '0';
					end if;
					counted_cycles := 0;
				else
					counted_cycles := counted_cycles + 1;
					enable_out <= '0';
				end if;
			end if;
			passive <= passive_count;
			active <= active_count;
			counted <= counted_cycles;
		end if;
	 end process;
end enable_generator_arq;

