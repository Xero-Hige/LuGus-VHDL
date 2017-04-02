library IEEE;
use IEEE.std_logic_1164.all;

entity ones_generator is
	generic (
		PERIOD: natural := 33000;
		COUNT: natural := 15500
	);
	
	port(
		clk: in std_logic;
		count_o: out std_logic
		);
end;

architecture ones_generator_arq of ones_generator is
begin
	process(clk)
		variable tmp_count: integer := 0;
		begin
			if rising_edge(clk) then
				tmp_count:=tmp_count + 1;
				if tmp_count < COUNT then
					count_o <= '1';
				end if;
				if tmp_count > COUNT then
					count_o <= '0';
				end if;
				if tmp_count >= PERIOD then
					tmp_count := 0;
				end if;
			end if;
		
	end process;
end;