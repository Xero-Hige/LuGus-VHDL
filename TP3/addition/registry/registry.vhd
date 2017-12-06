library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity registry is
	generic(TOTAL_BITS : integer := 32);
	port(
		enable: in std_logic := '0';
		reset: in std_logic := '0';
		clk: in std_logic := '0';
		D: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
		Q: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
	);
end;

architecture registry_arq of registry is
begin

	process(clk, reset, enable, D)
	begin
		if reset = '1' then
			Q <= (others => '0');
		elsif rising_edge(clk) then
			if enable = '1' then
				Q <= D;
			end if; --No va else para considerar todos los casos porque asi deja el valor anterior de Q.
		end if;
	end process;
end;