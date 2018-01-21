library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;


entity enable_generator is
	generic(CYCLE_COUNT: integer := 10);
	port(
		clk: in std_logic := '0';
		enable_in: in std_logic := '0';
		enable_out : out std_logic := '0'
	);
end entity;

architecture enable_generator_arq of enable_generator is
begin
	
	process(clk)
		variable tmp_count : integer := 0;
	begin
		if(enable_in = '1') then
			if(rising_edge(clk)) then
				if(tmp_count = CYCLE_COUNT) then
					tmp_count := 0;
					enable_out <= '1';
				else
					tmp_count := tmp_count + 1;
					enable_out <= '0';					
				end if;
			end if;
		end if;
	end process;
end enable_generator_arq;

