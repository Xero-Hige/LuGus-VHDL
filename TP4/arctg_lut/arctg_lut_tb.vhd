library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arctg_lut_tb is
end entity;

architecture arctg_lut_tb_arq of arctg_lut_tb is

	signal step_index  : integer := 0;
	signal angle : std_logic_vector(31 downto 0) := (others => '0');

	component arctg_lut is
		generic(TOTAL_BITS: integer := 32);
  	port(
    	step_index: in integer := 0;
    	angle: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
  	);
	end component;

	for arctg_lut_0 : arctg_lut use entity work.arctg_lut;

begin

	arctg_lut_0 : arctg_lut
		generic map(TOTAL_BITS => 32)
		port map(
			step_index  => step_index,
			angle  => angle
		);

	process
		type pattern_type is record
			i : integer;
			a : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			(0,"00000000001011010000000000000000"),
			(15,"00000000000000000000000001110010")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			step_index <= patterns(i).i;

			wait for 1 ns;

			assert patterns(i).a = angle report "BAD ANGLE, GOT: " & integer'image(to_integer(unsigned(angle)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
