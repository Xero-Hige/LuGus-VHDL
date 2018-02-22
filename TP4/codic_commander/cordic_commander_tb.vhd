library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_commander_tb is
end entity;

architecture cordic_commander_tb_arq of cordic_commander_tb is

	signal clk : std_logic := '0';
	signal mode: std_logic_vector(1 downto 0) := (others => '0');
	signal angle : std_logic_vector(31 downto 0) := (others => '0');

	component cordic_commander is
		generic(TOTAL_BITS : integer := 32);
		port(
		    clk : in std_logic := '0';
		    enable : in std_logic := '0';
		    mode : in  std_logic_vector(1 downto 0) := (others => '0');
		    angle : out std_logic_vector(TOTAL_BITS  - 1 downto 0) := (others => '0')
		   );
	end component;

begin

	cordic_commander_0 : cordic_commander
		port map(
			clk => clk,
			enable => '1',
			mode => mode,
			angle => angle
		);

	process
		type pattern_type is record
			m : std_logic_vector(1 downto 0);
			a : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00","00000000000000000000000000000000"),
			("00","00000000000000000000000000000000"),
			("01","00000000000000001011010000000000"),
			("11","11111111111111110100110000000000")

		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			mode <= patterns(i).m;
			clk <= '0';
			
			wait for 1 ns;

			clk <= '1';

			wait for 1 ns; 

			assert patterns(i).a = angle report "BAD ANGLE, EXPECTED: " & integer'image(to_integer(signed(patterns(i).a))) & " GOT: " & integer'image(to_integer(signed(angle)));
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
