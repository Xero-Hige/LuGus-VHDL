library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity four_port_multiplexer is
	generic(
		BITS:natural := 1);
	port (
		data_in_a: in std_logic_vector(BITS-1 downto 0); 	
		data_in_b: in std_logic_vector(BITS-1 downto 0);
		data_in_c: in std_logic_vector(BITS-1 downto 0);
		data_in_d: in std_logic_vector(BITS-1 downto 0);
		select_in: in std_logic_vector(1 downto 0); --2 bits, 4 opciones
		data_out: out std_logic_vector(BITS-1 downto 0)
	);
end;

architecture four_port_multiplexer_arq of four_port_multiplexer is
begin
	--El comportamiento se puede hacer de forma logica o por diagrama karnaugh.
	process(select_in)
	begin 
		SELECTED: case to_integer(unsigned(select_in)) is
			when 0 =>
				data_out <= data_in_a;
			when 1 =>
				data_out <= data_in_b;
			when 2 =>
				data_out <= data_in_c;
			when 3 =>
				data_out <= data_in_d;
			when others => --Redundante
		end case SELECTED;
	end process;

end;