library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity result_complementer_tb is
end entity;

architecture result_complementer_tb_arq of result_complementer_tb is

	signal result_in : std_logic_vector(5 downto 0) := (others => '0');

	signal sign_1_in  : std_logic := '0';
	signal sign_2_in : std_logic := '0';
	signal result_cout : std_logic := '0';

	signal result_out : std_logic_vector(5 downto 0) := (others => '0');

	component result_complementer is
		generic(
			BITS : natural := 16
		);

		port(
			in_result : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
			sign_1_in : in std_logic := '0';
			sign_2_in : in std_logic := '0';
			result_cout : in std_logic := '0';
			out_result : out std_logic_vector(BITS - 1 downto 0) := (others => '0')
		);
	end component;

	for result_complementer_0 : result_complementer use entity work.result_complementer;

begin

	result_complementer_0 : result_complementer
		generic map(BITS => 6)
		port map(
			in_result => result_in,
			sign_1_in => sign_1_in,
			sign_2_in => sign_2_in,
			result_cout => result_cout,
			out_result => result_out
		);

	process
		type pattern_type is record
			ir : std_logic_vector(5 downto 0); 
			s1 : std_logic;             
			s2 : std_logic;
			rco : std_logic;
			r : std_logic_vector(5 downto 0);
		end record;
	
	type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("000000",'0', '0', '0',"000000"),
			("000000",'1', '1', '0',"000000"),
			("000000",'0', '0', '1',"000000"),
			("000000",'1', '1', '1',"000000"),
			("000000",'0', '1', '1',"000000"),
			("000000",'1', '0', '1',"000000"),
			("000000",'0', '1', '0',"000000"),
			("000000",'1', '0', '0',"000000"),
			("111111",'0', '1', '0',"000001"),
			("111111",'1', '0', '0',"000001")
		);

	begin
		for i in patterns'range loop
			
			result_in <= patterns(i).ir;
			sign_1_in <= patterns(i).s1;
			sign_2_in <= patterns(i).s2;
			result_cout <= patterns(i).rco;

			--  Wait for the results.
			wait for 1 ns;
			--  Check the outputs.
			assert result_out = patterns(i).r report "BAD RESULT: " & integer'image(to_integer(unsigned(result_out)));
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end result_complementer_tb_arq;
