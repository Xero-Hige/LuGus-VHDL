library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity number_shifter_tb is
end entity;

architecture number_shifter_tb_arq of number_shifter_tb is

	signal man_in   : std_logic_vector(31 downto 0) := (others => '0');
	signal sign_1_in : std_logic := '0';
	signal sign_2_in : std_logic := '0';
	signal greater_exp : std_logic_vector(5 downto 0) := (others => '0');
	signal smaller_exp : std_logic_vector(5 downto 0) := (others => '0');
	signal man_out  : std_logic_vector(31 downto 0) := (others => '0');

	component number_shifter is
		generic(
			BITS : natural := 32;
			EXP_BITS : natural := 6
		);

		port(
			sign_1_in : in std_logic;
			sign_2_in : in std_logic;
			greater_exp : in std_logic_vector(EXP_BITS - 1 downto 0);
			smaller_exp : in std_logic_vector(EXP_BITS - 1 downto 0);
			man_in  : in  std_logic_vector(BITS - 1 downto 0);
			man_out : out std_logic_vector(BITS - 1 downto 0)
		);
	end component;
	
	for number_shifter_0 : number_shifter use entity work.number_shifter;

begin

	number_shifter_0 : number_shifter
		generic map(BITS => 32, EXP_BITS => 6)
		port map(
			man_in => man_in,
			sign_1_in => sign_1_in,
			sign_2_in => sign_2_in,
			greater_exp => greater_exp,
			smaller_exp => smaller_exp,
			man_out => man_out
		);

	process
		type pattern_type is record
			mi  : std_logic_vector(31 downto 0);
			s1 : std_logic;
			s2 : std_logic;
			ge : std_logic_vector(5 downto 0);
			se : std_logic_vector(5 downto 0);
			mo  : std_logic_vector(31 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("00000000000000000000000000000000",'0','0',"000000","000000","00000000000000000000000000000000"),
			("11000000000000000000000000000000",'0','0',"000001","000000","01100000000000000000000000000000"),
			("11000000000000000000000000000000",'1','0',"000001","000000","11100000000000000000000000000000"),
			("11000000000000000000000000000000",'1','1',"000001","000000","01100000000000000000000000000000"),
			("11000000000000000000000000000000",'0','1',"000001","000000","11100000000000000000000000000000"),
			("11000000000000000000000000000000",'0','0',"111111","000000","00000000000000000000000000000000"),
			("11000000000000000000000000000000",'0','1',"111111","000000","11111111111111111111111111111111")
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			man_in <= patterns(i).mi;
			sign_1_in <= patterns(i).s1;
			sign_2_in <= patterns(i).s2;
			greater_exp <= patterns(i).ge;
			smaller_exp <= patterns(i).se;
			
			wait for 1 ns;

			assert patterns(i).mo = man_out report "BAD SHIFTING, GOT: " & integer'image(to_integer(unsigned(man_out)));
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
