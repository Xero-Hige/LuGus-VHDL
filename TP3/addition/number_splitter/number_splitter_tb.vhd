library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity number_splitter_tb is
end entity;

architecture number_splitter_tb_arq of number_splitter_tb is

	signal number_in: std_logic_vector(22 downto 0);
	signal sign_out: std_logic;
	signal exp_out: std_logic_vector(5 downto 0);
	signal mant_out: std_logic_vector(15 downto 0);


	component number_splitter is
		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS:natural := 6);
		port (

			number_in: in std_logic_vector(TOTAL_BITS-1 downto 0);
			sign_out: out std_logic;
			exp_out: out std_logic_vector(EXP_BITS-1 downto 0);
			mant_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0)
		);
	end component;
	for number_splitter_0: number_splitter use entity work.number_splitter;

begin

	number_splitter_0: number_splitter port map(
			number_in => number_in,
			sign_out => sign_out,
			exp_out => exp_out,
			mant_out => mant_out
		);

	process
		type pattern_type is record
			 n : std_logic_vector(22 downto 0); --input number
			 s : std_logic; --output sign
			 m : std_logic_vector(15 downto 0); --output mantisa
			 e : std_logic_vector(5 downto 0); --output exponent
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("11111111111111111111111", '1', "1111111111111111", "111111"),
			("00000000000000000000000", '0', "0000000000000000", "000000"),
			("10101010101010101010101", '1', "0101010101010101", "010101")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     number_in <= patterns(i).n;
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert sign_out = patterns(i).s report "BAD SIGN: " & std_logic'image(sign_out) severity error;
	     assert mant_out = patterns(i).m report "BAD MANTISSA: " & integer'image(to_integer(unsigned(mant_out))) severity error;
	     assert exp_out = patterns(i).e report "BAD EXP: " & integer'image(to_integer(unsigned(exp_out))) severity error;
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
