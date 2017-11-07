library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_computer_tb is
end entity;

architecture sign_computer_tb_arq of sign_computer_tb is

	signal sign1_in : std_logic := '0';
	signal sign2_in : std_logic := '0';
	signal sign_out : std_logic := '0';

	component sign_computer is
  port(
    sign1_in : in std_logic;
    sign2_in : in std_logic;
    sign_out : out std_logic
  );
	end component;
	for sign_computer_0: sign_computer use entity work.sign_computer;

begin

		sign_computer_0: sign_computer port map(
			sign1_in => sign1_in,
			sign2_in => sign2_in,
			sign_out => sign_out
		);

	process
		type pattern_type is record
			 s1i : std_logic;
			 s2i : std_logic;
			 so : std_logic;
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			('0','0','0'),
			('0','1','1'),
			('1','0','1'),
			('1','1','0')
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     sign1_in <= patterns(i).s1i;
	     sign2_in <= patterns(i).s2i;
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert sign_out = patterns(i).so report "BAD SIGN: " & std_logic'image(sign_out) severity error;
	    
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
