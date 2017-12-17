library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity normalizer_tb is
end entity;

architecture normalizer_tb_arq of normalizer_tb is

	signal x_in : std_logic_vector(31 downto 0) := (others => '0');
	signal y_in : std_logic_vector(31 downto 0) := (others => '0');
	signal x_out : std_logic_vector(31 downto 0) := (others => '0');
	signal y_out : std_logic_vector(31 downto 0) := (others => '0');
	signal steps_applied : integer := 0;

	component normalizer is
		generic(TOTAL_BITS: integer := 32);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      steps_applied : in integer := 0;
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
	end component;

begin

	normalizer_0 : normalizer
		generic map(TOTAL_BITS => 32)
		port map(
			x_in => x_in,
			y_in	=> y_in,
			steps_applied => steps_applied,
			x_out => x_out,
			y_out => y_out
		);

	process
		type pattern_type is record
			xi : std_logic_vector(31 downto 0);
			yi : std_logic_vector(31 downto 0);
			sa : integer;
			xo : std_logic_vector(31 downto 0);
			yo : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 	0,	
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000"),
			("00000000000000010000000000000000",
			 "00000000000000010000000000000000",
			 	0,	
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000"),
			("00000000000000010000000000000000",
			 "00000000000000010000000000000000",
			  1,
			  "00000000000000001011010100000100",
			  "00000000000000001011010100000100")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			x_in <= patterns(i).xi;
			y_in <= patterns(i).yi;
			steps_applied <= patterns(i).sa;

			wait for 1 ns;

			assert patterns(i).xo = x_out	 report "BAD X, GOT: " & integer'image(to_integer(signed(x_out)));
			assert patterns(i).yo = y_out report "BAD Y, GOT: " & integer'image(to_integer(signed(y_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
