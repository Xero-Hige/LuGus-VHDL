library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_equalizer_tb is
end entity;

architecture exp_equalizer_tb_arq of exp_equalizer_tb is

	signal man_1_in   : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_1_in   : std_logic_vector(5 downto 0)  := (others => '0');
	signal man_2_in   : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_2_in   : std_logic_vector(5 downto 0)  := (others => '0');
	signal man_greater_out  : std_logic_vector(31 downto 0) := (others => '0');
	signal man_smaller_out  : std_logic_vector(31 downto 0) := (others => '0');
	signal exp_out    : std_logic_vector(5 downto 0)  := (others => '0');

	component exp_equalizer is
		generic(
			TOTAL_BITS : natural := 23;
			EXP_BITS   : natural := 6
		);

		port(
			man_1_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_1_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_2_in   : in  std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_2_in   : in  std_logic_vector(EXP_BITS - 1 downto 0);
			man_greater_out  : out std_logic_vector((TOTAL_BITS - EXP_BITS - 2) * 2 + 1 downto 0); --extended precision
			man_smaller_out  : out std_logic_vector((TOTAL_BITS - EXP_BITS - 2) * 2 + 1 downto 0);
			exp_out    : out std_logic_vector(EXP_BITS - 1 downto 0);
			difference : out unsigned(EXP_BITS - 1 downto 0)
		);
	end component;
	for exp_equalizer_0 : exp_equalizer use entity work.exp_equalizer;

begin

	exp_equalizer_0 : exp_equalizer
		generic map(TOTAL_BITS => 23, EXP_BITS => 6)
		port map(
			exp_1_in   => exp_1_in,
			exp_2_in   => exp_2_in,
			man_1_in   => man_1_in,
			man_2_in   => man_2_in,
			exp_out    => exp_out,
			man_greater_out  => man_greater_out,
			man_smaller_out  => man_smaller_out,
			difference => open
		);

	process
		type pattern_type is record
			m1  : std_logic_vector(15 downto 0);
			e1  : std_logic_vector(5 downto 0);
			m2  : std_logic_vector(15 downto 0);
			e2  : std_logic_vector(5 downto 0);
			mg : std_logic_vector(31 downto 0);
			ms : std_logic_vector(31 downto 0);
			eo  : std_logic_vector(5 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000000001", "000000", "0000000000000001", "000000", "00000000000000010000000000000000", "00000000000000010000000000000000", "000000"),
			("0000000000000001", "111110", "0000000000000001", "111111", "00000000000000010000000000000000", "00000000000000001000000000000000", "111111"),
			("0000000000000001", "111111", "0000000000101010", "110111", "00000000000000010000000000000000", "00000000000000000010101000000000", "111111")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			exp_1_in <= patterns(i).e1;
			exp_2_in <= patterns(i).e2;
			man_1_in <= patterns(i).m1;
			man_2_in <= patterns(i).m2;

			wait for 1 ns;

			assert patterns(i).mg = man_greater_out report "BAD MANTISSA 1, GOT: " & integer'image(to_integer(unsigned(man_greater_out)));
			assert patterns(i).ms = man_smaller_out report "BAD MANTISSA 2, GOT: " & integer'image(to_integer(unsigned(man_smaller_out)));
			assert patterns(i).eo = exp_out report "BAD EXP, GOT: " & integer'image(to_integer(unsigned(exp_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;