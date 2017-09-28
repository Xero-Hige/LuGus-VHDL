library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_multiplexer_tb is
end entity;

architecture binary_multiplexer_tb_arq of binary_multiplexer_tb is

  signal number1_in: std_logic_vector(5 downto 0);
  signal number2_in: std_logic_vector(5 downto 0);
  signal chooser: std_logic;
  signal mux_output: std_logic_vector(5 downto 0);


  component binary_multiplexer is

      generic(
  		  BITS:natural := 16
  	  );

      port(
        number1_in: in  std_logic_vector(BITS-1 downto 0);
        number2_in: in  std_logic_vector(BITS-1 downto 0);

        chooser: in std_logic;

        mux_output: out  std_logic_vector(BITS-1 downto 0)
    );
  end component;
	for binary_multiplexer_0: binary_multiplexer use entity work.binary_multiplexer;

begin

	binary_multiplexer_0: binary_multiplexer
    generic map(BITS => 6)
    port map(
      number1_in => number1_in,
      number2_in => number2_in,
      chooser => chooser,
      mux_output => mux_output
		);

	process
		type pattern_type is record
			n1 : std_logic_vector(5 downto 0);
			n2 : std_logic_vector(5 downto 0);
			c : std_logic;
			o: std_logic_vector(5 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			("111111", "000000", '0', "111111"),
			("111111", "000000", '1', "000000"),
			("000001", "000001", '0', "000001"),
			("000001", "000001", '1', "000001"),
			("000001", "000010", '0', "000001"),
			("000001", "000010", '1', "000010")
		);

		begin

	  for i in patterns'range loop
	     --  Set the inputs.
	     number1_in <= patterns(i).n1;
       number2_in <= patterns(i).n2;
       chooser <= patterns(i).c;
	     wait for 1 ms;

       assert mux_output = patterns(i).o report "WRONG SELECTION, EXPECTED: " & integer'image(to_integer(unsigned(patterns(i).o))) & " GOT: " & integer'image(to_integer(unsigned(mux_output)));

	     --  Check the outputs.
    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
