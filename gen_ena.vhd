library ieee;
use ieee.std_logic_ll64.all;

entity gen_ena is
	port{
		clk: in std_logic;
		rst: in std_logic;
		ena: out std_logic;
	};
end;
	
	
architecture gen_ena_arq of gen_ena is
	variable count: integer := 0;
begin
	cont: process(clk)
	begin
		if rst = '1' then
			ena := '0';
		elsif rising_edge(clk) then	
			count := count + 1;
			if count = '10' then
				count := 0;
				ena := '1';
			else
				ena := 0;
			end if;
		end if;
end;		