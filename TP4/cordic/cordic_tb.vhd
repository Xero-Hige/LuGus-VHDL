library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_tb is
end entity;

architecture cordic_tb_arq of cordic_tb is

	signal x_in: std_logic_vector(31 downto 0) := (others => '0');
	signal y_in: std_logic_vector(31 downto 0) := (others => '0');
	signal angle : std_logic_vector(31 downto 0) := (others => '0');
	signal x_out : std_logic_vector(31 downto 0) := (others => '0');
	signal y_out : std_logic_vector(31 downto 0) := (others => '0');

	component cordic is
		generic(TOTAL_BITS: integer := 32; STEPS: integer := 16);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
	end component;

	for cordic_0 : cordic use entity work.cordic;

begin

	cordic_0 : cordic
		port map(
			x_in => x_in,
			y_in => y_in,
			angle => angle,
			x_out => x_out,
			y_out => y_out
		);

	process
		type pattern_type is record
			xi : std_logic_vector(31 downto 0);
			yi : std_logic_vector(31 downto 0);
			a : std_logic_vector(31 downto 0);
			xo : std_logic_vector(31 downto 0);
			yo : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000000000000000000000"),
			("00000000000000010000000000000000",
			 "00000000000000010000000000000000",
			 "00000000001011010000000000000000",
			 "00000000000000000000000000000000",
			 "00000000000000010110101000001010")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			x_in <= patterns(i).xi;
			y_in <= patterns(i).yi;
			angle <= patterns(i).a;
			
			wait for 1 ns;

			assert patterns(i).xo = x_out report "BAD X, GOT: " & integer'image(to_integer(signed(x_out)));
			assert patterns(i).yo = y_out report "BAD Y, GOT: " & integer'image(to_integer(signed(y_out)));
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
