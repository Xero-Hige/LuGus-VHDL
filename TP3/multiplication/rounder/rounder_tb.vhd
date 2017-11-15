library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rounder_tb is
end entity;

architecture rounder_tb_arq of rounder_tb is

	signal man_in: std_logic_vector(7 downto 0) := (others => '0');
	signal exp_in: std_logic_vector(2 downto 0) := (others => '0');
	signal man_out: std_logic_vector(5 downto 0) := (others => '0');
	signal exp_out: std_logic_vector(2 downto 0) := (others => '0');
	signal exponent_addition_cout: std_logic := '0';


	component rounder is

		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS: natural := 6
		);

		port (
			exponent_addition_cout: in std_logic;
			man_in: in std_logic_vector(TOTAL_BITS - EXP_BITS downto 0);
			exp_in: in std_logic_vector(EXP_BITS - 1 downto 0);
			man_out : out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
			exp_out : out std_logic_vector(EXP_BITS - 1 downto 0)
		);
	end component;
	
	for rounder_0: rounder use entity work.rounder;

begin

	rounder_0: rounder 
		generic map(TOTAL_BITS => 10, EXP_BITS => 3)
		port map(
			exponent_addition_cout => exponent_addition_cout,
			man_in => man_in,
			exp_in => exp_in,
			man_out => man_out,
			exp_out => exp_out
		);

	process
		type pattern_type is record
			 mi : std_logic_vector(7 downto 0);
			 ei : std_logic_vector(2 downto 0);
			 mo : std_logic_vector(5 downto 0);
			 ec : std_logic; 
			 eo : std_logic_vector(2 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000","000","000000",'0',"000"),
			("11111111","000","000000",'0',"000"),
			("10000001","110","000000",'0',"100")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     man_in <= patterns(i).mi;
	     exp_in <= patterns(i).ei;
	     exponent_addition_cout <= patterns(i).ec;	
	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert man_out = patterns(i).mo report "BAD MANTISSA: " & integer'image(to_integer(unsigned(man_out))) severity error;
			 assert exp_out = patterns(i).eo report "BAD EXPONENT: " & integer'image(to_integer(unsigned(exp_out))) severity error;
	   
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
