library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity biaser_tb is
end entity;

architecture biaser_tb_arq of biaser_tb is

	signal exp_in: std_logic_vector(2 downto 0) := (others => '0');
	signal exp_out: std_logic_vector(2 downto 0) := (others => '0');

	component biaser is

		generic(
			EXP_BITS: natural := 6
		);

		port (
			exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;
	
	for biaser_0: biaser use entity work.biaser;

begin

	biaser_0: biaser
		generic map(EXP_BITS => 3)
		port map(
			exp_in => exp_in,
			exp_out => exp_out
		);

	process
		type pattern_type is record
			 ei : std_logic_vector(2 downto 0);
			 eo : std_logic_vector(2 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("000","101"),
			("001","110")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     exp_in <= patterns(i).ei;
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert exp_out = patterns(i).eo report "BAD EXPONENT: " & integer'image(to_integer(unsigned(exp_out))) severity error;
	   
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
