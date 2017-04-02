library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_counter is

	port (
	clk: in std_logic;
	rst: in std_logic;
	ena: in std_logic;
	counter_out: out std_logic_vector(3 downto 0);
	carry_out: out std_logic
	);

end;

architecture bcd_counter_arq of bcd_counter is
	begin
		--el comportamiento se puede hacer de forma logica o por diagrama karnaugh.
		process(clk,rst)
		variable count: integer range 0 to 10;
		begin
			if rst = '1' then
				counter_out 	<= (others => '0');
				carry_out 		<= '0';
				count 			:= 	0;
			elsif rising_edge(clk) then
				if ena = '1' then
					count:=count + 1;
					if count 	=  9 then
						carry_out	<= '1';
					elsif count = 10 then
						count 		:= 	0;
						carry_out 	<= '0';
					else
						carry_out 	<= '0';
					end if;
				end if;
			end if;
			counter_out <= std_logic_vector(to_unsigned(count,4));	end process;
end;
