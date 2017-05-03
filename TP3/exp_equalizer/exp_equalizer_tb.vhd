library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exp_equalizer_tb is
end entity;

architecture exp_equalizer_tb_arq of exp_equalizer_tb is

  signal man_1_in: std_logic_vector(15 downto 0);
  signal exp_1_in: std_logic_vector(5 downto 0);
  signal man_2_in: std_logic_vector(15 downto 0);
  signal exp_2_in: std_logic_vector(5 downto 0);
  signal man_1_out: std_logic_vector(15 downto 0);
  signal exp_1_out: std_logic_vector(5 downto 0);
  signal man_2_out: std_logic_vector(15 downto 0);
  signal exp_2_out: std_logic_vector(5 downto 0);
  signal difference: unsigned(5 downto 0);


	component exp_equalizer is
    generic(
  		TOTAL_BITS:natural := 23;
  		EXP_BITS:natural := 6
  	);

  	port (
  		man_1_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
  		exp_1_in: in std_logic_vector(EXP_BITS-1 downto 0);
  		man_2_in: in std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
  		exp_2_in: in std_logic_vector(EXP_BITS-1 downto 0);
  		man_1_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
  		exp_1_out: out std_logic_vector(EXP_BITS-1 downto 0);
  		man_2_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0);
  		exp_2_out: out std_logic_vector(EXP_BITS-1 downto 0);
      difference: out unsigned(EXP_BITS-1 downto 0)
  	);
  end component;
	for exp_equalizer_0: exp_equalizer use entity work.exp_equalizer;

begin

	exp_equalizer_0: exp_equalizer
    generic map(TOTAL_BITS => 23, EXP_BITS => 6)
    port map(
			exp_1_in => exp_1_in,
      exp_2_in => exp_2_in,
      man_1_in => man_1_in,
      man_2_in => man_2_in,
      exp_1_out => exp_1_out,
      exp_2_out => exp_2_out,
      man_1_out => man_1_out,
      man_2_out => man_2_out,
      difference => difference

		);

	process
		type pattern_type is record
			 m1 : std_logic_vector(15 downto 0);
			 e1 : std_logic_vector(5 downto 0);
			 m2 : std_logic_vector(15 downto 0);
			 e2 : std_logic_vector(5 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("1010101010101010", "101011", "1010101010101011", "101010"),
			("1010101010101010", "010101", "0000000000000000", "111111")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     exp_1_in <= patterns(i).e1;
       exp_2_in <= patterns(i).e2;
       man_1_in <= patterns(i).m1;
       man_2_in <= patterns(i).m2;

	     wait for 1 ms;

       report "DIFF: " & integer'image(to_integer(difference));
	     --  Check the outputs.
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
