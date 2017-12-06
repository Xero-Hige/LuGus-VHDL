library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_xor is

	port (
		bit1_in: in  std_logic := '0';
		bit2_in: in  std_logic := '0';
		result: out std_logic := '0'
	);
end;

architecture bit_xor_arq of bit_xor is
begin

	process(bit1_in, bit2_in)
	begin
		result <= bit1_in xor bit2_in;
	end process;

end architecture;
