library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_ram_tb is
end entity;

architecture dual_port_ram_tb_arq of dual_port_ram_tb is

	signal data_in : std_logic_vector (0 downto 0) := (others => '0');
  signal address : std_logic_vector (13 downto 0) := (others	=> '0');
  signal enable : std_logic := '0';
  signal sub_ram : std_logic_vector(7 downto 0) := (others => '0');
  signal write_enable : std_logic := '0';
  signal reset : std_logic := '0';
  signal clk : std_logic := '0';
  signal data_out : std_logic_vector (0 downto 0) := (others => '0');

	component dual_port_ram is
	port (
    data_in : in std_logic_vector (0 downto 0) := (others => '0');
    address : in std_logic_vector (13 downto 0) := (others => '0');
    sub_ram : in std_logic_vector(7 downto 0) := (others => '0');
    enable : in std_logic := '0';
    clk : in std_logic := '0';
    write_enable : in std_logic := '0';
    reset : in std_logic := '0';
    data_out : out std_logic_vector (0 downto 0) := (others => '0')
  );
	end component;

begin

	dual_port_ram_0 : dual_port_ram
		port map(
			data_in => data_in,
	    address => address,
	    enable => enable,
	    sub_ram => sub_ram, 
	    write_enable => write_enable,
	    reset => reset,
	    clk => clk,
	    data_out => data_out
		);

	process

		type pattern_type is record
			din : std_logic_vector(0 downto 0);
			sr : std_logic_vector(7 downto 0);
			add : std_logic_vector(13 downto 0);
			wen : std_logic;
			dot : std_logic_vector(0 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0",
				"00000000",
			 "00000000000000",
			 '0',
			 "0"),
			("1",
				"00000001",
			 "00000000000000",
			 '1',
			 "0"),
			("1",
				"00000010",
			 "00000000000000",
			 '1',
			 "0"),
			("1",
				"00000100",
			 "00000000000000",
			 '1',
			 "0"),
			("1",
				"10000000",
			 "00000000000000",
			 '1',
			 "0"),
			("0",
				"00000001",
			 "00000000000000",
			 '0',
			 "1"),
			("0",
				"00000010",
			 "00000000000000",
			 '0',
			 "1"),
			("0",
				"00000100",
			 "00000000000000",
			 '0',
			 "1"),
			("0",
				"10000000",
			 "00000000000000",
			 '0',
			 "1"),
			("0",
				"00000001",
			 "00000000000000",
			 '0',
			 "1"),
			("1",
				"00000001",
			 "00000000010000",
			 '1',
			 "0"),
			("0",
				"00000001",
			 "00000000010000",
			 '0',
			 "1")
			
		);


	begin
		clk <= '0';
		enable <= '1';
		reset <= '0';

		for i in patterns'range loop

			clk <= '0';
			wait for 1 ns;

			--  Set the inputs.
			data_in <= patterns(i).din;
			address <= patterns(i).add;
			sub_ram <= patterns(i).sr;
			write_enable <= patterns(i).wen;

			clk	<= '1';
			
			wait for 1 ns; 

			assert patterns(i).dot = data_out report "BAD SAVED VALUE, EXPECTED: " & std_logic'image(patterns(i).dot(0)) & " GOT: " & std_logic'image(data_out(0));

	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
