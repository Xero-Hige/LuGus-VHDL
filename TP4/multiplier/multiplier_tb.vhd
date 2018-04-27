library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_tb is
end entity;

architecture multiplier_tb_arq of multiplier_tb is

	signal op_1_in : std_logic_vector(31 downto 0) := (others => '0');
	signal op_2_in : std_logic_vector(31 downto 0) := (others => '0');
	signal result_out : std_logic_vector(63 downto 0) := (others => '0');

	component multiplier is
    port(
      op_1_in: in std_logic_vector(31 downto 0) := (others => '0');
      op_2_in: in std_logic_vector(31 downto 0) := (others => '0');
      result_out: out std_logic_vector(63 downto 0) := (others => '0')
    );
	end component;

begin

	multiplier_0 : multiplier
		port map(
			op_1_in => op_1_in,
			op_2_in => op_2_in,
			result_out => result_out
		);

	process
		type pattern_type is record
			o1 : std_logic_vector(31 downto 0);
			o2 : std_logic_vector(31 downto 0);
			r : std_logic_vector(63 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			( "00000000000000000000000000000000","00000000000000000000000000000000","0000000000000000000000000000000000000000000000000000000000000000"),
			( "00000000000000000000000000000010","00000000000000000000000000000010","0000000000000000000000000000000000000000000000000000000000000100"),
			( "00000000000000000000010000000000","00000000000000000000001000000000","0000000000000000000000000000000000000000000010000000000000000000"),
			( "11111111111111111111111111111111","11111111111111111111111111111111","1111111111111111111111111111111000000000000000000000000000000001")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			op_1_in <= patterns(i).o1;
			op_2_in <= patterns(i).o2;

			wait for 1 ns;

			assert patterns(i).r = result_out	 report "BAD RESULT,  GOT: " & integer'image(to_integer(unsigned(result_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
