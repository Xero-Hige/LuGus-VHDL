library IEEE;
use IEEE.std_logic_1164.all;

entity FFD is
	port(
		enable: in std_logic;
		reset: in std_logic;
		clk: in std_logic;
		Q: out std_logic;
		D: in std_logic
		);
end;

architecture FFD_Funct of FFD is
begin
	process(clk, reset)
	begin
		if reset = '1' then
			Q <= '0';
		elsif rising_edge(clk) then
			if enable = '1' then
				Q <= D;
			end if; --No va else para considerar todos los casos porque asi deja el valor anterior de Q.
		end if;
	end process;
end;

