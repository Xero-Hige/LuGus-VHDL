library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_xor_tb is
end entity;

architecture bit_xor_tb_arq of bit_xor_tb is

	signal bit1 : std_logic;
	signal bit2 : std_logic;
	signal result : std_logic;

	component bit_xor is
		port (
		bit1_in: in  std_logic := '0';
		bit2_in: in  std_logic := '0';
		result: out std_logic := '0'
	);
	end component;

begin

	bit_xor_0 : bit_xor
		port map(
			bit1_in => bit1,
			bit2_in => bit2,
			result => result
		);

	process
		type pattern_type is record
			b1 : std_logic;             
			b2 : std_logic;             
			r : std_logic;             
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			('0','0','0'),
			('0','1','1'),
			('1','0','1'),
			('1','1','0')
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			bit1 <= patterns(i).b1;
			bit2 <= patterns(i).b2;

			--  Wait for the results.
			wait for 1 ns;
			--  Check the outputs.
			assert result = patterns(i).r report "BAD RESULT: " & std_logic'image(result);
		
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end bit_xor_tb_arq;
