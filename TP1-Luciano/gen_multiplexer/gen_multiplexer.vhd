library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gen_multiplexer is
	generic(
		PORT_SIZE: natural := 1; 
		PORT_QUANT: natural := 2); --Port quantity, la cantidad de puertos de entrada
	port (
		
		data_in: in 
		data_out: out std_logic_vector(PORT_SIZE-1 downto 0);
	);
end;

architecture contBCD_arq of contBCD is
begin
	--El comportamiento se puede hacer de forma logica o por diagrama karnaugh.
	process(clk,rst)
		variable count: integer range 0 to 10;
	begin 
		if rst = '1' then	
			s <= (others => '0');
			co <= '0';
		elsif rising_edge(clk) then
			if ena = '1' then
				count:=count + 1;
				if count = 9 then
					co <= '1';
				elsif count = 10 then	
					count := 0;
					co <= '0';
				else
					co <= '0';
				end if;
			end if;	
		end if;
		s <= std_logic_vector(TO_UNSIGNED(count,4));
	end process;

end;