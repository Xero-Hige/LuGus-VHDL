library IEEE;
use IEEE.std_logic_1164.all;




entity FFD_Array is
	generic (
		SIZE: natural := 12
	);
	
	port(
		enable: in std_logic;
		reset: in std_logic;
		clk: in std_logic;
		Q: out std_logic_vector(SIZE-1 downto 0);
		D: in std_logic_vector(SIZE-1 downto 0)
		);
end;

architecture FFD_Array_Funct of FFD_Array is
begin
	process(clk, reset)
	begin
		for i in 0 to SIZE-1 loop
			if reset = '1' then
				Q(i) <= '0';
			elsif rising_edge(clk) then
				if enable = '1' then
					Q(i) <= D(i);
				end if; --No va else para considerar todos los casos porque asi deja el valor anterior de Q.
			end if;
		end loop;
	end process;
end;