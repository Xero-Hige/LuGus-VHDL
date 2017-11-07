library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity class_adder_tb is
end entity;

architecture class_adder_tb_arq of class_adder_tb is

	signal number1_in: std_logic_vector(3 downto 0);
	signal number2_in: std_logic_vector(3 downto 0);
	signal result: std_logic_vector(3 downto 0);
	signal cout: std_logic;
	signal cin: std_logic;


	component class_adder is
		generic(N: integer:= 4);
		port(
				 number1_in: in std_logic_vector(N-1 downto 0);
				 number2_in: in std_logic_vector(N-1 downto 0);
				 cin:        in std_logic;

				 result:     out std_logic_vector(N-1 downto 0);
				 cout:       out std_logic
		);

  end component;
	for class_adder_0: class_adder use entity work.class_adder;

begin

	class_adder_0: class_adder port map(
			number1_in => number1_in,
			number2_in => number2_in,
			result => result,
		  cout => cout,
			cin => cin
		);

	process
		type pattern_type is record
			  in1 : std_logic_vector(3 downto 0); --input number
			  in2 : std_logic_vector(3 downto 0); --output
				cin : std_logic;
			  r: std_logic_vector(3 downto 0); --output mantisa
			  co : std_logic; --output exponent
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("1111", "1111",'0', "1110", '1'),
			("0000", "0000",'1', "0001", '0'),
			(std_logic_vector(to_unsigned(2,4)), std_logic_vector(to_unsigned(2,4)),'0', std_logic_vector(to_unsigned(4,4)), '0'),
			(std_logic_vector(to_unsigned(4,4)), std_logic_vector(to_unsigned(4,4)),'0', std_logic_vector(to_unsigned(8,4)), '0')
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     number1_in <= patterns(i).in1;
       number2_in <= patterns(i).in2;
			 cin <= patterns(i).cin;
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert cout = patterns(i).co report "BAD CARRY: " & std_logic'image(cout) & ", ON " & integer'image(to_integer(unsigned(number1_in))) & " + " & integer'image(to_integer(unsigned(number2_in))) severity error;
	     assert result = patterns(i).r report "BAD RESULT: " & integer'image(to_integer(unsigned(result))) & ", ON " & integer'image(to_integer(unsigned(number1_in))) & " + " & integer'image(to_integer(unsigned(number2_in))) severity error;
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
