library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoBCD is
	port(
		ena: in std_logic; --Estara conectado al anodo del BCD para habilitarlo o no
		count: in std_logic_vector(3 downto 0); --Bits del contador
		a: out std_logic;
		b: out std_logic;
		c: out std_logic;
		d: out std_logic;
		e: out std_logic;
		f: out std_logic;
		g: out std_logic;
		dp: out std_logic;
		anod: out std_logic
	);
end;
	
	
architecture decoBCD_arq of decoBCD is	
begin
	--El 7 segmentos funciona con logica invertida
	process(count,ena) --Se va a activar con un cambio de valor o con un cambio de enable
	
	begin
		--Seteo todas las salidas en 0 para solo "apagar" las que necesite por cada numero
		a <= '0';
		b <='0';
		c <= '0';
		d <= '0';
		e <= '0';
		f <= '0';
		g <= '0';
		dp <= '1'; --En este caso siempre apagado
		CHECK: case to_integer(unsigned(count)) is
			when 0 =>
				g <= '1';
			when 1 =>
				a <= '1';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
			when 2 => 
				c <= '1';
				f <= '1';
			when 3 =>
				e <= '1';
				f <= '1';
			when 4 =>
				a <= '1';
				d <= '1';
				e <= '1';
			when 5 =>
				b <= '1';
				e <= '1';
			when 6 => 
				b <= '1';
			when 7 =>
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
			when 8 =>
				--no cambia nada
			when 9 =>
				d <= '1';
				e <= '1';
			when others =>
				a <= '1';
				b <= '1';
				c <= '1';
				d <= '1';
				e <= '1';
				f <= '1';
				g <= '1';
		end case CHECK;	
				
		anod <= not(ena); 
	end process;
		
	
end;		