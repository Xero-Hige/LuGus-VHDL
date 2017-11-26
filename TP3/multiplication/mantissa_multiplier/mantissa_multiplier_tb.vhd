library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mantissa_multiplier_tb is
end entity;

architecture mantissa_multiplier_tb_arq of mantissa_multiplier_tb is

	signal man1_in: std_logic_vector(5 downto 0);
	signal man2_in: std_logic_vector(5 downto 0);
	signal result: std_logic_vector(7 downto 0);


	component mantissa_multiplier is

		generic(
			BITS:natural := 16
		);

		port (
			man1_in: in std_logic_vector(BITS - 1 downto 0);
			man2_in: in std_logic_vector(BITS - 1 downto 0);
			result: out std_logic_vector(BITS + 1 downto 0) --Add one to shift if necessary
		);
	end component;
	for mantissa_multiplier_0: mantissa_multiplier use entity work.mantissa_multiplier;

begin

	mantissa_multiplier_0: mantissa_multiplier 
		generic map(BITS => 6)
		port map(
			man1_in => man1_in,
			man2_in => man2_in,
			result => result
		);

	process
		type pattern_type is record
			 m1 : std_logic_vector(5 downto 0);
			 m2 : std_logic_vector(5 downto 0);
			 r : std_logic_vector(7 downto 0); 
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("000000","000000","01000000"),
			("111111","111111","11111100")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     man1_in <= patterns(i).m1;
	     man2_in <= patterns(i).m2;
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert result = patterns(i).r report "BAD RESULT: " & integer'image(to_integer(unsigned(result))) severity error;
	   
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
