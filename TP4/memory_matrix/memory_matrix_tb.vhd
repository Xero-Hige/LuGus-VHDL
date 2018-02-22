library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_matrix_tb is
end entity;

architecture memory_matrix_tb_arq of memory_matrix_tb is

	signal finished : boolean := false;
	signal x_write: std_logic_vector(9 downto 0) := (others => '0');
  signal y_write: std_logic_vector(9 downto 0) := (others => '0');
  signal write_data: std_logic_vector(0 downto 0) := (others => '0');
  signal write_enable: std_logic := '0';
      
  signal clk: std_logic := '0';
  signal enable: std_logic := '0';
 	signal reset: std_logic := '0';

  signal x_read: std_logic_vector(9 downto 0) := (others => '0');
  signal y_read: std_logic_vector(9 downto 0) := (others => '0');
  signal read_data : std_logic_vector(0 downto 0) := (others => '0');

	component memory_matrix is
    generic(ROWS: integer := 350; COLUMNS: integer := 350; CLK_DELAY_COUNT: integer := 9);
    port(
      x_write: in std_logic_vector(9 downto 0) := (others => '0');
      y_write: in std_logic_vector(9 downto 0) := (others => '0');
      write_data: in std_logic_vector(0 downto 0) := (others => '0');
      write_enable: in std_logic := '0';
      
      clk: in std_logic := '0';
      enable: in std_logic := '0';
      reset: in std_logic := '0';

      x_read: in std_logic_vector(9 downto 0) := (others => '0');
      y_read: in std_logic_vector(9 downto 0) := (others => '0');
      read_data : out std_logic_vector(0 downto 0) := (others => '0')
    );
	end component;


	begin

	memory_matrix_0 : memory_matrix
		generic map(CLK_DELAY_COUNT => 9)
		port map(
			x_write => x_write,
      y_write => y_write,
      write_data => write_data,
      write_enable => write_enable,
      clk => clk,
      enable => enable,
      reset => reset,
			x_read => x_read,
      y_read => y_read,
      read_data => read_data
		);


	process(clk)
	begin
		if(not finished) then
			clk <= not(clk) after 1 ns;
		end if;
	end process;

	process

		type pattern_type is record
			xin : std_logic_vector(9 downto 0);
			yin : std_logic_vector(9 downto 0);
			wd : std_logic_vector(0 downto 0);
			wen : std_logic;

			xo : std_logic_vector(9 downto 0);
			yo : std_logic_vector(9 downto 0);

			dot : std_logic_vector(0 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("0000000100",
			 "0000000100",
			 "1",
			 '1',
			 "0000000000",
			 "0000000000",
			 "0"),
			("0000000011",
			 "0000000011",
			 "1",
			 '1',
			 "0000000000",
			 "0000000000",
			 "0"),
			("0000000000",
			 "0000000000",
			 "0",
			 '0',
			 "0000000100",
			 "0000000100",
			 "1"),
			("0000000000",
			 "0000000000",
			 "0",
			 '0',
			 "0000000011",
			 "0000000011",
			 "1"),
			("0000000000",
			 "0000000000",
			 "0",
			 '0',
			 "0000000011",
			 "0000000011",
			 "1"),
			("0000000000",
			 "0000000000",
			 "0",
			 '0',
			 "0000000011",
			 "0000000011",
			 "1")

			);


	begin
		reset <= '0';
		enable <= '1';

		for i in patterns'range loop

			--  Set the inputs.
			x_write <= patterns(i).xin;
			y_write <= patterns(i).yin;

			write_data <= patterns(i).wd;
			write_enable <= patterns(i).wen;

			x_read <= patterns(i).xo;
			y_read <= patterns(i).yo;
			
			enable <= '1'; 

			wait for 20 ns;

			assert patterns(i).dot = read_data report "BAD SAVED VALUE, EXPECTED: " & std_logic'image(patterns(i).dot(0)) & " GOT: " & std_logic'image(read_data(0));

	
			--  Check the outputs.
		end loop;

		reset <= '1';

		wait for 20 ns;

		assert read_data = "0" report "BAD SAVED VALUE, EXPECTED: " & std_logic'image('0') & " GOT: " & std_logic'image(read_data(0));


		finished <= true;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
