library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_read_proxy_tb is
end entity;

architecture memory_read_proxy_tb_arq of memory_read_proxy_tb is

	signal x_in : std_logic_vector(9 downto 0) := (others => '0');
  signal y_in : std_logic_vector(9 downto 0) := (others => '0');
  signal x_out : std_logic_vector(9 downto 0) := (others => '0');
  signal y_out : std_logic_vector(9 downto 0) := (others => '0');
  signal value_out : std_logic_vector(0 downto 0) := (others => '0');

	component memory_read_proxy is

		generic(STARTING_X: integer := 0; STARTING_Y: integer := 0);
		port(
			x_in: in std_logic_vector(9 downto 0) := (others => '0');
      y_in: in std_logic_vector(9 downto 0) := (others => '0');
      memory_value: in std_logic_vector(0 downto 0) := (others => '0');
      x_out: out std_logic_vector(9 downto 0) := (others => '0');
      y_out: out std_logic_vector(9 downto 0) := (others => '0');
      proxy_value: out std_logic_vector(0 downto 0) := (others => '0')
		);
	end component;

begin

	memory_read_proxy_0 : memory_read_proxy
		generic map(STARTING_X => 4, STARTING_Y => 3)
		port map(
			x_in => x_in,
			x_out => x_out,
			y_in => y_in,
			y_out => y_out,
			memory_value => "1",
			proxy_value => value_out
		);

	process
		type pattern_type is record
			xi : std_logic_vector(9 downto 0);
			yi : std_logic_vector(9 downto 0);
			xo : std_logic_vector(9 downto 0);
			yo : std_logic_vector(9 downto 0);
			vo : std_logic_vector(0 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000","0000000000","0000000000","0000000000","0"),
			("0000000011","0000000010","0000000000","0000000000","0"),
			("0000001110","0000000010","0000000000","0000000000","0"),
			("0000000011","0000011111","0000000000","0000000000","0"),
			("0000000111","0000000111","0000000011","0000000100","1")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			x_in <= patterns(i).xi;
			y_in <= patterns(i).yi;
			
			wait for 1 ns; 

			assert patterns(i).vo = value_out report "BAD VALUE, EXPECTED: " & std_logic'image(patterns(i).vo(0)) & " GOT: " & std_logic'image(value_out(0));
			assert patterns(i).xo = x_out report "BAD X, EXPECTED: " & integer'image(to_integer(signed(patterns(i).xo))) & " GOT: " & integer'image(to_integer(signed(x_out)));
			assert patterns(i).yo = y_out report "BAD Y, GOT: " & integer'image(to_integer(signed(y_out)));
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
