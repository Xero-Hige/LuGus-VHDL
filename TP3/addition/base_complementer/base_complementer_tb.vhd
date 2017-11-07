library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity base_complementer_tb is
end entity;

architecture base_complementer_tb_arq of base_complementer_tb is

	signal number_in  : std_logic_vector(15 downto 0) := (others => '0');
	signal number_out : std_logic_vector(15 downto 0) := (others => '0');

	component base_complementer is
		generic(
			TOTAL_BITS : natural := 16
		);

		port(
      number_in: in  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      number_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );

	end component;

	for base_complementer_0 : base_complementer use entity work.base_complementer;

begin

	base_complementer_0 : base_complementer
		generic map(TOTAL_BITS => 16)
		port map(
			number_in  => number_in,
			number_out  => number_out
		);

	process
		type pattern_type is record
			ni : integer;
			no : integer;
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			(1,-1),
			(0,0),
			(10,-10)
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			number_in <= std_logic_vector(to_signed(patterns(i).ni,16));

			wait for 1 ns;

			assert patterns(i).no = to_integer(signed(number_out)) report "BAD COMPLEMENT, GOT: " & integer'image(to_integer(signed(number_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
