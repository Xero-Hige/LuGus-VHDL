library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_register_tb is
end entity;

architecture shift_register_tb_arq of shift_register_tb is

	signal d_in : std_logic_vector(31 downto 0) := (others => '0');
	signal rst_in: std_logic:='0';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal q_out: std_logic_vector(31 downto 0) := (others => '0');


	component shift_register is
		generic(REGISTRY_BITS : integer := 32;
	 				STEPS : integer := 4);
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			D: in std_logic_vector(REGISTRY_BITS - 1 downto 0);
			Q: out std_logic_vector(REGISTRY_BITS - 1 downto 0)
		);
  end component;

	for shift_register_0: shift_register use entity work.shift_register;

begin

	shift_register_0: shift_register
		generic map(REGISTRY_BITS => 32, STEPS => 4)
		port map(
				enable => enable_in,
				reset => rst_in,
				clk => clk_in,
				D => d_in,
				Q => q_out
		);

	process
		type pattern_type is record
			  en : std_logic;
			  r: std_logic;
			  clk: std_logic;
			  d: std_logic_vector(31 downto 0);
			 	q: std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range<>) of pattern_type;
		constant patterns : pattern_array := (
			('1', '0','1', "00000000000000000000000000000001", "00000000000000000000000000000000"),
			('1', '0','1', "00000000000000000000000000000010", "00000000000000000000000000000000"),
			('1', '0','1', "00000000000000000000000000000011", "00000000000000000000000000000000"),
			('1', '0','1', "00000000000000000000000000000100", "00000000000000000000000000000001"),
			('1', '0','1', "00000000000000000000000000000000", "00000000000000000000000000000010"),
			('1', '0','1', "00000000000000000000000000000000", "00000000000000000000000000000011"),
			('1', '0','1', "00000000000000000000000000000000", "00000000000000000000000000000100"),
			('1', '0','1', "00000000000000000000000000000000", "00000000000000000000000000000000")
		);

		begin

	  for i in patterns'range loop
	     
	  	d_in <= patterns(i).d;
	  	enable_in <= patterns(i).en;
	  	rst_in <= patterns(i).r;
	  	clk_in <= patterns(i).clk;

	     --  Wait for the results.
	     wait for 1 ns;
	     --  Check the outputs.
			 assert q_out = patterns(i).q report "BAD Q, EXPECTED " & integer'image(to_integer(unsigned(patterns(i).q))) & " GOT: " & integer'image(to_integer(unsigned(q_out)));
    
	     clk_in <= '0'; --reset clock

	     wait for 1 ns;

    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
