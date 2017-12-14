library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity angle_step_applier_tb is
end entity;

architecture angle_step_applier_tb_arq of angle_step_applier_tb is

	signal x_in: std_logic_vector(31 downto 0) := (others => '0');
	signal y_in: std_logic_vector(31 downto 0) := (others => '0');
	signal z_in: std_logic_vector(31 downto 0) := (others => '0');
	signal step_index : integer := 0;
	signal x_out : std_logic_vector(31 downto 0) := (others => '0');
	signal y_out : std_logic_vector(31 downto 0) := (others => '0');
	signal z_out : std_logic_vector(31 downto 0) := (others => '0');

	component angle_step_applier is
		generic(TOTAL_BITS: integer := 32);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      z_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      step_index : in integer := 0;
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      z_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
	end component;

	for angle_step_applier_0 : angle_step_applier use entity work.angle_step_applier;

begin

	angle_step_applier_0 : angle_step_applier
		port map(
			x_in => x_in,
			y_in => y_in,
			z_in => z_in,
			step_index => step_index,
			x_out => x_out,
			y_out => y_out,
			z_out => z_out
		);

	process
		type pattern_type is record
			si : integer;
			xi : std_logic_vector(31 downto 0);
			yi : std_logic_vector(31 downto 0);
			zi : std_logic_vector(31 downto 0);
			xo : std_logic_vector(31 downto 0);
			yo : std_logic_vector(31 downto 0);
			zo : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			(0, 
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000",
			"00000000000000000000000000000000"),
			(0, 
			"00000000000000010000000000000000",
			"00000000000000000000000000000000",
			"00000000001011010000000000000000",
			"00000000000000010000000000000000",
			"00000000000000010000000000000000",
			"00000000000000000000000000000000"),
			(0, 
			"00000000000000010000000000000000",
			"00000000000000010000000000000000",
			"00000000001011010000000000000000",
			"00000000000000000000000000000000",
			"00000000000000100000000000000000",
			"00000000000000000000000000000000")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			x_in <= patterns(i).xi;
			y_in <= patterns(i).yi;
			z_in <= patterns(i).zi;
			step_index <= patterns(i).si;

			wait for 1 ns;

			assert patterns(i).xo = x_out report "BAD X, GOT: " & integer'image(to_integer(signed(x_out)));
			assert patterns(i).yo = y_out report "BAD Y, GOT: " & integer'image(to_integer(signed(y_out)));
			assert patterns(i).zo = z_out report "BAD Z, GOT: " & integer'image(to_integer(signed(z_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
