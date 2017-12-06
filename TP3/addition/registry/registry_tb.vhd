library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registry_tb is
end entity;

architecture registry_tb_arq of registry_tb is

	signal d_in : std_logic_vector(31 downto 0) := (others => '0');
	signal rst_in: std_logic:='0';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	signal q_out: std_logic_vector(31 downto 0) := (others => '0');


	component registry is
		generic(TOTAL_BITS : integer := 32);
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			D: in std_logic_vector(TOTAL_BITS - 1 downto 0);
			Q: out std_logic_vector(TOTAL_BITS - 1 downto 0)
		);
  end component;

	for registry_0: registry use entity work.registry;

begin

	registry_0: registry
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
			('1', '0','1', "00000000000000000000000000000001", "00000000000000000000000000000001"),
			('0', '0','1', "00000000000000000000000000000000", "00000000000000000000000000000001"),
			('0', '1','0', "00000000000111111000000000111111", "00000000000000000000000000000000"),
			('0', '1','1', "00000000000111111000000000111111", "00000000000000000000000000000000")
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
			 assert q_out = patterns(i).q report "BAD Q: " & integer'image(to_integer(unsigned(q_out)));
    
	     clk_in <= '0'; --reset clock

	     wait for 1 ns;

    end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
