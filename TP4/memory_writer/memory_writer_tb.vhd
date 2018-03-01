library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_writer_tb is
end entity;

architecture memory_writer_tb_arq of memory_writer_tb is

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal enable : std_logic := '0';
	signal real_x : std_logic_vector(31 downto 0) := (others => '0');
	signal real_y : std_logic_vector(31 downto 0) := (others => '0');
	signal pixel_x : std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_y : std_logic_vector(9 downto 0) := (others => '0');
	signal pixel_out : std_logic_vector(0 downto 0) := (others => '0');

	component memory_writer is

    generic(ROWS : integer := 350; COLUMNS : integer := 350; BITS : integer := 32);
		port(
			clk : in std_logic := '0';
			enable : in std_logic := '0';
			rst : in std_logic := '0';
			pixel_x : out std_logic_vector(9 downto 0) := (others => '0');
			pixel_y : out std_logic_vector(9 downto 0) := (others => '0');
			pixel_on : out std_logic_vector(0 downto 0) := (others => '0')
		);
	end component;

begin

	memory_writer_0 : memory_writer
		port map(
			clk => clk,
			enable => enable,
			rst => rst,
			pixel_on => pixel_out
		);

	process(clk)
	begin
		enable <= '1';
		rst <= not(rst) after 5000 ns;
		clk <=  not(clk) after 10 ns;

	end process;
end;
