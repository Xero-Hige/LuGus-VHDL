library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_computer_tb is
end entity;

architecture sign_computer_tb_arq of sign_computer_tb is

	signal man_1_in: std_logic_vector(15 downto 0) := (others => '0');
  signal man_2_in: std_logic_vector(15 downto 0) := (others => '0');
  signal sign_1_in: std_logic := '0';
  signal sign_2_in: std_logic := '0';
  signal man_greater_in: std_logic_vector(15 downto 0) := (others => '0');
  signal pre_complemented_result: std_logic_vector(31 downto 0) := (others => '0');
  signal complemented_result: std_logic_vector(31 downto 0) := (others => '0');
  signal sign_out: std_logic := '0';


	component sign_computer is

    generic(
		 BITS : natural := 16
	  );

    port(
      man_1_in: in  std_logic_vector(BITS - 1 downto 0) := (others => '0');
      man_2_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      sign_1_in: in std_logic := '0';
      sign_2_in: in std_logic := '0';
      man_greater_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      pre_complemented_result: in std_logic_vector(BITS*2 - 1 downto 0) := (others => '0');
      complemented_result: in std_logic_vector(BITS*2 - 1 downto 0) := (others => '0');
      sign_out: out std_logic := '0'
    );
 	end component;
	
for sign_computer_0 : sign_computer use entity work.sign_computer;

begin

	sign_computer_0 : sign_computer
		generic map(BITS => 16)
		port map(
			man_1_in => man_1_in,
			man_2_in => man_2_in,
			sign_1_in => sign_1_in,
			sign_2_in => sign_2_in,
			man_greater_in => man_greater_in,
			pre_complemented_result => pre_complemented_result,
			complemented_result => complemented_result,
			sign_out => sign_out
		);

	process
		type pattern_type is record
			m1 : std_logic_vector(15 downto 0);
			m2 : std_logic_vector(15 downto 0);
			s1 : std_logic;
			s2 : std_logic;
			mg : std_logic_vector(15 downto 0);
			pcr : std_logic_vector(31 downto 0);
			cr : std_logic_vector(31 downto 0);
			so : std_logic;
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000000000000","0000000000000000",'0','0',"0000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",'0'),
			("0000000000000000","0000000000000000",'1','1',"0000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",'1'),
			("0000000000000000","1111111111111111",'0','1',"1111111111111111","00000000000000000000000000000000","00000000000000000000000000000000",'1'),
			("0000000000000000","1111111111111111",'1','0',"1111111111111111","00000000000000000000000000000000","00000000000000000000000000000000",'0'),
			("0000000000000000","1111111111111111",'0','1',"0000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",'0'),
			("0000000000000000","1111111111111111",'1','0',"0000000000000000","00000000000000000000000000000000","00000000000000000000000000000000",'1'),
			("0000000000000000","1111111111111111",'0','1',"0000000000000000","10000000000000000000000000000000","00000000000000000000000000000000",'1'),
			("0000000000000000","1111111111111111",'1','0',"0000000000000000","10000000000000000000000000000000","00000000000000000000000000000000",'0')
		);

	begin
		for i in patterns'range loop
			--  Set the inputs.
			man_1_in <= patterns(i).m1;
			man_2_in <= patterns(i).m2;
			sign_1_in <= patterns(i).s1;
			sign_2_in <= patterns(i).s2;
			man_greater_in <= patterns(i).mg;
			pre_complemented_result <= patterns(i).pcr;
			complemented_result <= patterns(i).cr;

			wait for 1 ms;

			assert patterns(i).so = sign_out report "BAD RESULT, GOT: " & std_logic'image(sign_out);

			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
