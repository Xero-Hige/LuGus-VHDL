library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_based_complementer_tb is
end entity;

architecture sign_based_complementer_arq of sign_based_complementer_tb is

	signal sign_1_in : std_logic := '0';
	signal sign_2_in : std_logic := '0';
	signal man_in : std_logic_vector(15 downto 0);
	signal man_out : std_logic_vector(15 downto 0);

	component sign_based_complementer is
		generic(
			BITS : natural := 16
		);

		port(
			sign_1_in   : in  std_logic;
			sign_2_in   : in  std_logic;
			man_in   : in  std_logic_vector(BITS - 1 downto 0);
			man_out : out std_logic_vector(BITS -1 downto 0)
		);
	end component;
	for sign_based_complementer_0 : sign_based_complementer use entity work.sign_based_complementer;

begin

	sign_based_complementer_0 : sign_based_complementer
		generic map(BITS => 16)
		port map(
			sign_1_in => sign_1_in,
			sign_2_in => sign_2_in,
			man_in => man_in,
			man_out => man_out
		);

	process
		type pattern_type is record
			s1  : std_logic;
			s2  : std_logic;
			mi  : std_logic_vector(15 downto 0);
			mo  : std_logic_vector(15 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			('0', '0', "0000000000000000", "0000000000000000"),
			('0', '1', "0000000000000000", "0000000000000000"),
			('1', '0', "0000000000000000", "0000000000000000"),
			('1', '1', "0000000000000000", "0000000000000000"),
			('0', '1', "0000000000000001", "1111111111111111"),
			('1', '1', "0000000000000001", "0000000000000001"),
			('1', '0', "0000000000000001", "1111111111111111")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			sign_1_in <= patterns(i).s1;
			sign_2_in <= patterns(i).s2;
			man_in <= patterns(i).mi;

			wait for 1 ns;

			assert patterns(i).mo = man_out report "BAD COMPLEMENT, GOT: " & integer'image(to_integer(signed(man_out)));

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
