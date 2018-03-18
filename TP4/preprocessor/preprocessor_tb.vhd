library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity preprocessor_tb is
end entity;

architecture preprocessor_tb_arq of preprocessor_tb is

	signal x_in : std_logic_vector(31 downto 0) := (others => '0');
	signal y_in : std_logic_vector(31 downto 0) := (others => '0');
	signal angle_in : std_logic_vector(31 downto 0) := (others => '0');
	signal x_out : std_logic_vector(31 downto 0) := (others => '0');
	signal y_out : std_logic_vector(31 downto 0) := (others => '0');
	signal angle_out : std_logic_vector(31 downto 0) := (others => '0');

	component preprocessor is
		generic(TOTAL_BITS: integer := 32);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_in : in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
	end component;

begin

	preprocessor_0 : preprocessor
		generic map(TOTAL_BITS => 32)
		port map(
			x_in => x_in,
			y_in	=> y_in,
			angle_in => angle_in,
			x_out => x_out,
			y_out => y_out,
			angle_out => angle_out
		);

	process
		type pattern_type is record
			xi : std_logic_vector(31 downto 0);
			yi : std_logic_vector(31 downto 0);
			ai : std_logic_vector(31 downto 0);
			xo : std_logic_vector(31 downto 0);
			yo : std_logic_vector(31 downto 0);
			ao : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000",	
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000"),
			("00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000",	
			 "00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000"),
			("00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "00000000000000000000000001000101",	
			 "00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "00000000000000000000000001000101"),
			("00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "00000000000000000000000001100000",	
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000001",
			 "00000000000000000000000000000110"),
			("00000000000000000000000000000000",
			 "00000000000000000000000000000001",
			 "00000000000000000000000001100000",	
			 "11111111111111111111111111111111",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000110"),
			("00000000000000000000000000000001",
			 "00000000000000000000000000000000",
			 "11111111111111111111111110100000",	
			 "00000000000000000000000000000000",
			 "11111111111111111111111111111111",
			 "11111111111111111111111111111010")

		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			x_in <= patterns(i).xi;
			y_in <= patterns(i).yi;
			angle_in <= patterns(i).ai;

			wait for 1 ns;

			assert patterns(i).xo = x_out	 report "BAD X, GOT: " & integer'image(to_integer(signed(x_out)));
			assert patterns(i).yo = y_out report "BAD Y, GOT: " & integer'image(to_integer(signed(y_out)));
			assert patterns(i).ao = angle_out report "BAD ANGLE, GOT: " & integer'image(to_integer(signed(angle_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
