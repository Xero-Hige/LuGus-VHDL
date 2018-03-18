library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
    port(
      clk: in std_logic := '0';
      rst: in std_logic := '0'; 
      ena: in std_logic := '0';

      hs: out std_logic := '0';
      vs: out std_logic := '0';
      red_o: out std_logic;
      grn_o: out std_logic;
      blu_o: out std_logic
    );
	 
	 attribute loc : string;
	 
	--attribute loc of clk: signal is "C9";
	--attribute loc of rst: signal is "H13";
	--attribute loc of ena: signal is "D18";

	--attribute loc of hs: signal is "F15";
	--attribute loc of vs: signal is "F14";
	--attribute loc of red_o: signal is "H14";
	--attribute loc of grn_o: signal is "H15";
	--attribute loc of blu_o: signal is "G15";

end display;

architecture display_arq of display is

  constant MIN_X : integer := 145;
  constant MAX_X : integer := 145 + 350;
  constant MIN_Y : integer := 65;
  constant MAX_Y : integer := 65 + 350;
    
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

  component vga_ctrl is
    port (
      mclk: in std_logic;
      red_i: in std_logic;
      grn_i: in std_logic;
      blu_i: in std_logic;
      hs: out std_logic;
      vs: out std_logic;
      red_o: out std_logic;
      grn_o: out std_logic;
      blu_o: out std_logic;
      pixel_row: out std_logic_vector(9 downto 0);
      pixel_col: out std_logic_vector(9 downto 0)
    );
  end component;

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

  component memory_read_proxy is

    generic(STARTING_X: integer := 0; STARTING_Y: integer := 0);
    port(
      x_in: in std_logic_vector(9 downto 0) := (others => '0');
      y_in: in std_logic_vector(9 downto 0) := (others => '0');
      memory_value: in std_logic_vector(0 downto 0) := (others => '0');
      x_out: out std_logic_vector(9 downto 0) := (others => '0');
      y_out: out std_logic_vector(9 downto 0) := (others => '0');
      proxy_value: out std_logic_vector(0 downto 0) := (others => '0')
    );
  end component;

  signal x_vga_to_proxy : std_logic_vector(9 downto 0) := (others => '0');
  signal y_vga_to_proxy : std_logic_vector(9 downto 0) := (others => '0');

  signal x_proxy_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  signal y_proxy_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  
  signal x_cordic_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  signal y_cordic_to_ram : std_logic_vector(9 downto 0) := (others => '0');

  signal writer_to_memory_x : std_logic_vector(9 downto 0) := (others => '0');
  signal writer_to_memory_y : std_logic_vector(9 downto 0) := (others => '0');

  signal pixel_to_vga : std_logic_vector(0 downto 0) := (others => '0');
  signal pixel_to_proxy : std_logic_vector(0 downto 0) := (others => '0');
  signal pixel_to_matrix : std_logic_vector(0 downto 0) := (others => '0');

  signal red : std_logic := '0';
  signal green : std_logic := '0';
  signal blue : std_logic := '0';

  --For cordic--

  signal vsync : std_logic := '0';
  signal memory_values_rst : std_logic := '0';

  
  begin

    memory_matrix_0 : memory_matrix
    generic map(CLK_DELAY_COUNT => 0)
    port map(
      x_write => writer_to_memory_x,
      y_write => writer_to_memory_y,
      write_data => pixel_to_matrix,
      write_enable => '1',
      clk => clk,
      enable => ena,
      reset => rst,
      x_read => x_proxy_to_ram,
      y_read => y_proxy_to_ram,
      read_data => pixel_to_proxy
    );

    vga_controller_0: vga_ctrl
      port map(
        mclk => clk,
        red_i => pixel_to_vga(0),
        grn_i => pixel_to_vga(0),
        blu_i => ena,
        hs => hs,
        vs => vsync,
        red_o => red,
        grn_o => green,
        blu_o => blue,
        pixel_row => y_vga_to_proxy,
        pixel_col => x_vga_to_proxy
    );

    memory_writer_0 : memory_writer
    port map(
      clk => clk,
      enable => ena,
      rst =>  memory_values_rst,
      pixel_x => writer_to_memory_x,
      pixel_y => writer_to_memory_y,
      pixel_on => pixel_to_matrix
    );

    memory_read_proxy_0 : memory_read_proxy
    generic map(STARTING_X => 145, STARTING_Y => 65)
    port map(
      x_in => x_vga_to_proxy,
      x_out => x_proxy_to_ram,
      y_in => y_vga_to_proxy,
      y_out => y_proxy_to_ram,
      memory_value => pixel_to_proxy,
      proxy_value => pixel_to_vga
    );

    vs <= vsync;

    red_o <= red;
    grn_o <= green;
    blu_o <= blue;

    memory_values_rst <= '0' when (
      to_integer(unsigned(x_vga_to_proxy)) > MIN_X and 
      to_integer(unsigned(y_vga_to_proxy)) > MIN_Y )
      else '1';

end architecture;