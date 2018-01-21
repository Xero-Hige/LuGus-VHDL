library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_writer_tb is
end entity;

architecture memory_writer_tb_arq of memory_writer_tb is

	signal real_x : std_logic_vector(31 downto 0) := (others => '0');
	signal real_y : std_logic_vector(31 downto 0) := (others => '0');
	signal pixel_x : std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_y : std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_out : std_logic_vector(0 downto 0) := (others => '0');

	component memory_writer is

    generic(ROWS : integer := 350; COLUMNS : integer := 350; BITS : integer := 32);
		port(
			real_x_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
			real_y_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
			pixel_x_in : in std_logic_vector(9 downto 0) := (others => '0');
			pixel_y_in : in std_logic_vector(9 downto 0) := (others => '0');
			pixel_on : out std_logic_vector(0 downto 0) := (others => '0')
		);
	end component;

begin

	memory_writer_0 : memory_writer
		port map(
			real_x_in => real_x,
			real_y_in => real_y,
			pixel_x_in => pixel_x,
			pixel_y_in => pixel_y,
			pixel_on => pixel_out
		);

	process

		type pattern_type is record
			px : std_logic_vector(9 downto 0);
			py : std_logic_vector(9 downto 0);

			po : std_logic_vector(0 downto 0);
		end record;
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000","0000000000","0"),
			("0010101111","1110001000","1"),
			("1110001000","0010101111","1"),
			("0000010000","0000010000","0"),
			("0101011110","0011000000","0"),
			("0111000111","0101011110","0"),
			("0101011110","0101011110","1")
		);


	begin
		real_x <= "00000000000000010000000000000000";
		real_y <= "00000000000000010000000000000000";

		for i in patterns'range loop
			pixel_x <= patterns(i).px;
			pixel_y <= patterns(i).py;

			wait for 1 ns;

			assert patterns(i).po = pixel_out report "BAD VALUE, EXPECTED: " & std_logic'image(patterns(i).po(0)) & " GOT: " & std_logic'image(pixel_out(0));
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
