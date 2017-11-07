library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity expanded_mantissa_adder_tb is
end entity;

architecture expanded_mantissa_adder_tb_arq of expanded_mantissa_adder_tb is

	signal man_1_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal man_2_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal result : std_logic_vector(31 downto 0) := (others => '0');
	signal cout : std_logic := '0';

	component expanded_mantissa_adder is
		generic(
			BITS : natural := 16
		);

		port(
			man_1_in : in std_logic_vector(BITS - 1 downto 0);
			man_2_in : in std_logic_vector(BITS - 1 downto 0);
			result : out std_logic_vector(BITS - 1 downto 0);
			cout : out std_logic
		);
	end component;
	for expanded_mantissa_adder_0 : expanded_mantissa_adder use entity work.expanded_mantissa_adder;

begin

	expanded_mantissa_adder_0 : expanded_mantissa_adder
		generic map(BITS => 32)
		port map(
			man_1_in => man_1_in,
			man_2_in => man_2_in,
			result => result,
			cout => cout
		);

	process
		type pattern_type is record
			m1  : std_logic_vector(31 downto 0);
			m2  : std_logic_vector(31 downto 0);
			r : std_logic_vector(31 downto 0);
			co : std_logic;
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",'0'),
			("11111111111111111111111111111111","00000000000000000000000000000000","11111111111111111111111111111111",'0'),
			("11111111111111110000000000000000","00000000000000001111111111111111","11111111111111111111111111111111",'0'),
			("10000000000000000000000000000000","10000000000000000000000000000000","00000000000000000000000000000000",'1')
			
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			man_1_in <= patterns(i).m1;
			man_2_in <= patterns(i).m2;

			wait for 1 ns;

			assert patterns(i).r = result report "BAD RESULT, GOT: " & integer'image(to_integer(unsigned(result)));
			assert patterns(i).co = cout report "BAD CARRY, GOT: " & std_logic'image(cout);

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
