library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity anod_enabler_decoder is
	port(
		binary_in: in std_logic_vector(1 downto 0); --"2 bit vector to switch between the 4 possible anod values"
		code_out: out std_logic_vector(3 downto 0) --4 bit output to switch between anod
	);
end;
	
	
architecture anod_enabler_decoder_arq of anod_enabler_decoder is	
begin
	process(binary_in)
	
	begin
		--Set all values as deactivated
		code_out <= (others => not('0'));
		
		CHECK: case to_integer(unsigned(binary_in)) is
			when 0 =>
				code_out(0) <= not('1');
			when 1 =>
				code_out(1) <= not('1');
			when 2 => 
				code_out(2) <= not('1');
			when 3 =>
				code_out(3) <= not('1');
			when others => --redundant
		end case CHECK;	
				
	end process;
		
	
end;		