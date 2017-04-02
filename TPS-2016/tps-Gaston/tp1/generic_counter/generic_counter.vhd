library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity generic_counter is
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
end;

architecture generic_counter_arq of generic_counter is
begin
	--El comportamiento se puede hacer de forma logica o por diagrama karnaugh.
	process(clk,rst)
		variable tmp_count: integer range 0 to MAX_COUNT+1;
	begin
		if rst = '1' then
			count <= (others => '0');
			carry_o <= '0';
		elsif rising_edge(clk) then
			if ena = '1' then
				tmp_count:=tmp_count + 1;
				if tmp_count = MAX_COUNT then
					carry_o <= '1';
				elsif tmp_count = MAX_COUNT+1 then
					tmp_count := 0;
					carry_o <= '0';
				else
					carry_o <= '0';
				end if;
			end if;
		end if;
		count <= std_logic_vector(TO_UNSIGNED(tmp_count,BITS));
	end process;

end;
