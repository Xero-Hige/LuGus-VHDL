library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity normalizer_tb is
end entity;

architecture normalizer_tb_arq of normalizer_tb is

	signal man_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal exp_in : std_logic_vector(5 downto 0) := (others => '0');
	signal cin : std_logic := '0';
	signal man_out : std_logic_vector(15 downto 0) := (others => '0');
	signal exp_out : std_logic_vector(5 downto 0) := (others => '0');

	component normalizer is
		generic(
			TOTAL_BITS : natural := 23;
			EXP_BITS : natural := 6
		);

		port(
			man_in : in std_logic_vector((TOTAL_BITS - EXP_BITS - 1)*2 - 1 downto 0); --number enters in double precision
			exp_in : in std_logic_vector(EXP_BITS - 1 downto 0);
			cin : in std_logic; --To check if the sum had a carry
			man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;

	for normalizer_0 : normalizer use entity work.normalizer;

begin

	normalizer_0 : normalizer
		generic map(TOTAL_BITS => 23, EXP_BITS => 6)
		port map(
			man_in => man_in,
			exp_in => exp_in,
			cin => cin,
			man_out => man_out,
			exp_out => exp_out
		);

	process
		type pattern_type is record
			mi  : std_logic_vector(31 downto 0);
			ei  : std_logic_vector(5 downto 0);
			ci : std_logic;
			mo  : std_logic_vector(15 downto 0);
			eo  : std_logic_vector(5 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000","000000",'0',"0000000000000000","000000"),
			("00000000000000000000000000000000","111111",'0',"0000000000000000","000000"),
			("00000000000000000000000000000001","011111",'0',"0000000000000000","000000"),
			("01000000000000000000000000000000","111111",'1',"0100000000000000","111111"),
			("00000111000000000000000000000000","000101",'0',"1100000000000000","000000")

		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			man_in <= patterns(i).mi;
			exp_in <= patterns(i).ei;
			cin <= patterns(i).ci;

			wait for 1 ns;

			assert patterns(i).mo = man_out report "BAD MANTISSA, GOT: " & integer'image(to_integer(unsigned(man_out)));
			assert patterns(i).eo = exp_out report "BAD EXPONENT, GOT: " & integer'image(to_integer(unsigned(exp_out)));

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
