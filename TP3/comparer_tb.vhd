library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparer_tb is
end entity;

architecture comparer_tb_arq of comparer_tb is

	signal number1_in: std_logic_vector(22 downto 0);
	signal number2_in: std_logic_vector(22 downto 0);

	signal first_greater: std_logic;
	signal second_greater: std_logic;
	signal equals: std_logic;

	component number_splitter is
		generic(
			BITS:natural := 16
		);

		port (
			number1_in: in  std_logic_vector(BITS-1 downto 0);
			number2_in: in  std_logic_vector(BITS-1 downto 0);
			first_greater: out std_logic;
			second_greater: out std_logic;
			equals: out std_logic
		);
	end component;
	
	for comparer_0: comparer use entity work.comparer;

begin

	comparer_0: comparer port map(
			number1_in => number1_in,
			number2_in => number2_in,
			first_greater => first_greater,
			second_greater => second_greater,
			equals => equals
		);

	process
		type pattern_type is record
			 n1: std_logic_vector(5 downto 0); --input number 1
			 n2: std_logic_vector(5 downto 0); --input number 2
			 fg : std_logic; --output first greter
			 sg : std_logic; --output second greater
			 eq : std_logic; --output equals
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("00000", "00000", '0', '0','1'),
			("00001", "00000", '1', '0','0'),
			("00000", "00001", '0', '1','0')
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     number1_in <= patterns(i).n1;
     	     number2_in <= patterns(i).n2;
	     
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
	     assert first_greater = 	patterns(i).fg report "BAD FIRST GREATER:" & integer'image(to_integer(unsigned(number1_in))) & " AND " & integer'image(to_integer(unsigned(number2_in))) severity error;
	     assert second_greater = 	patterns(i).sg report "BAD SECOND GREATER: " & integer'image(to_integer(unsigned(number1_in))) & " AND " & integer'image(to_integer(unsigned(number2_in))) severity error;
	     assert equals = 		patterns(i).eq report "BAD EQUALS:" & integer'image(to_integer(unsigned(number1_in))) & " AND " & integer'image(to_integer(unsigned(number2_in))) severity error;
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end comparer_tb_arq;
