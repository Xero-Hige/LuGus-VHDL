library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity number_swapper_tb is
end entity;

architecture number_swapper_tb_arq of number_swapper_tb is

	signal man_1_in   : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_1_in   : std_logic_vector(5 downto 0)  := (others => '0');
	signal man_2_in   : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_2_in   : std_logic_vector(5 downto 0)  := (others => '0');
	signal man_greater_out  : std_logic_vector(15 downto 0) := (others => '0');
	signal man_smaller_out  : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_greater_out  : std_logic_vector(5 downto 0)  := (others => '0');
	signal exp_smaller_out  : std_logic_vector(5 downto 0) := (others => '0');

	component number_swapper is
		generic(
			TOTAL_BITS : natural := 23;
			EXP_BITS   : natural := 6
		);

		port(
			man_1_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_1_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_2_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_2_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_greater_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			man_smaller_out  : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_greater_out  : out std_logic_vector(EXP_BITS - 1 downto 0);
			exp_smaller_out  : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;
	for number_swapper_0 : number_swapper use entity work.number_swapper;

begin

	number_swapper_0 : number_swapper
		generic map(TOTAL_BITS => 23, EXP_BITS => 6)
		port map(
			exp_1_in   => exp_1_in,
			exp_2_in   => exp_2_in,
			man_1_in   => man_1_in,
			man_2_in   => man_2_in,
			exp_greater_out  => exp_greater_out,
			exp_smaller_out => exp_smaller_out,
			man_greater_out  => man_greater_out,
			man_smaller_out  => man_smaller_out
		);

	process
		type pattern_type is record
			m1  : std_logic_vector(15 downto 0);
			e1  : std_logic_vector(5 downto 0);
			m2  : std_logic_vector(15 downto 0);
			e2  : std_logic_vector(5 downto 0);
			mg : std_logic_vector(15 downto 0);
			ms : std_logic_vector(15 downto 0);
			eg  : std_logic_vector(5 downto 0);
			es  : std_logic_vector(5 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000000001", "000000", "0000000000000001", "000000", "0000000000000001", "0000000000000001", "000000","000000"),
			("0000000000000001", "000100", "0000000000000001", "000000", "0000000000000001", "0000000000000001", "000100","000000"),
			("0000000110000000", "000011", "0000000000000001", "000001", "0000000110000000", "0000000000000001", "000011","000001"),
			("0000000000000001", "000001", "0000000011000000", "000011", "0000000011000000", "0000000000000001", "000011","000001"),
			("1111111111111111", "111110", "0000000000000000", "111111", "0000000000000000", "1111111111111111", "111111","111110")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			exp_1_in <= patterns(i).e1;
			exp_2_in <= patterns(i).e2;
			man_1_in <= patterns(i).m1;
			man_2_in <= patterns(i).m2;

			wait for 1 ns;

			assert patterns(i).mg = man_greater_out report "BAD MANTISSA G, GOT: " & integer'image(to_integer(unsigned(man_greater_out)));
			assert patterns(i).ms = man_smaller_out report "BAD MANTISSA S, GOT: " & integer'image(to_integer(unsigned(man_smaller_out)));
			assert patterns(i).eg = exp_greater_out report "BAD EXP G, GOT: " & integer'image(to_integer(unsigned(exp_greater_out)));
			assert patterns(i).es = exp_smaller_out report "BAD EXP S, GOT: " & integer'image(to_integer(unsigned(exp_smaller_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
