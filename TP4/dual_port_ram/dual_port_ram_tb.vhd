library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_ram_tb is
end entity;

architecture dual_port_ram_tb_arq of dual_port_ram_tb is

	signal DATA_IN : std_logic_vector (35 downto 0) := (others => '0');
  signal ADDRESS : std_logic_vector (8 downto 0) := (others	=> '0');
  signal ENABLE : std_logic := '0';
  signal WRITE_EN : std_logic := '0';
  signal SET_RESET : std_logic := '0';
  signal CLK : std_logic := '0';
  signal DATA_OUT : std_logic_vector (35 downto 0) := (others => '0');

	component dual_port_ram is
  port (
    DATA_IN : in std_logic_vector (35 downto 0);
    ADDRESS : in std_logic_vector (8 downto 0);
    ENABLE : in std_logic;
    WRITE_EN : in std_logic;
    SET_RESET : in std_logic;
    CLK : in std_logic;
    DATA_OUT : out std_logic_vector (35 downto 0)
  );
	end component;

begin

	dual_port_ram_0 : dual_port_ram
		port map(
			DATA_IN => DATA_IN,
	    ADDRESS => ADDRESS,
	    ENABLE => ENABLE, 
	    WRITE_EN => WRITE_EN,
	    SET_RESET => SET_RESET,
	    CLK => CLK,
	    DATA_OUT => DATA_OUT
		);

	process

		type pattern_type is record
			din : std_logic_vector(35 downto 0);
			add : std_logic_vector(8 downto 0);
			wen : std_logic;
			dot : std_logic_vector(35 downto 0);
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array := (
			("000000000000000000000000000000000011",
			 "000000000",
			 '1',
			 "000000000000000000000000000000000000"),
			("000000000000000000000000000000000001",
			 "000000000",
			 '1',
			 "000000000000000000000000000000000011"),
			("000000000000000000000000000000000001",
			 "000000000",
			 '0',
			 "000000000000000000000000000000000011")
		);


	begin
		CLK <= '0';
		ENABLE <= '1';
		SET_RESET <= '0';

		for i in patterns'range loop
			--  Set the inputs.
			DATA_IN <= patterns(i).din;
			ADDRESS <= patterns(i).add;
			WRITE_EN <= patterns(i).wen;
			
			CLK	<= '1';
			
			wait for 1 ns; 

			assert patterns(i).dot = DATA_OUT report "BAD SAVED VALUE, EXPECTED: " & integer'image(to_integer(unsigned(patterns(i).dot))) & " GOT: " & integer'image(to_integer(unsigned(DATA_OUT(31 downto 0))));

			CLK <= '0';
	
			--  Check the outputs.
		end loop;
		assert false report "end of test" severity note;
		wait;
	end process;
end;
