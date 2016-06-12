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
	begin
		--El comportamiento se puede hacer de forma logica o por diagrama karnaugh.
		process(clk_in,rst_in)
		variable tmp_count: integer range 0 to 33099;
		begin
			if rst_in = '1' then
				tmp_count := 0;
			elsif rising_edge(clk_in) then
				if ena_in = '1' then
					tmp_count:=tmp_count + 1;
					if tmp_count = 33000 then
						out_1 <= '1';
						out_2 <= '0';
					elsif tmp_count = 33001 then
						out_1 <= '0';
						out_2 <= '1';
					elsif tmp_count = 33002 then
						tmp_count := 0;
						out_1 <= '0';
						out_2 <= '0';
					else
						out_1 <= '0';
						out_2 <= '0';
					end if;
				end if;
			end if;
		end process;
end;