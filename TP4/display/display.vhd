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
      red_o: out std_logic_vector(2 downto 0) := (others => '0');
      grn_o: out std_logic_vector(2 downto 0) := (others => '0');
      blu_o: out std_logic_vector(1 downto 0) := (others => '0')
    );

end display;

architecture display_arq of display is
    
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
      red_o: out std_logic_vector(2 downto 0);
      grn_o: out std_logic_vector(2 downto 0);
      blu_o: out std_logic_vector(1 downto 0);
      pixel_row: out std_logic_vector(9 downto 0);
      pixel_col: out std_logic_vector(9 downto 0)
    );
  end component;

  component memory_writer is

    generic(ROWS : integer := 350; COLUMNS : integer := 350; BITS : integer := 32);
    port(
      real_x_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      real_y_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      pixel_x_in : in std_logic_vector(9 downto 0) := (others => '0');
      pixel_y_in : in std_logic_vector(9 downto 0) := (others => '0');
      pixel_on : out std_logic_vector(0 downto 0) := (others => '0')
    );
  end component;

  signal x_vga_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  signal y_vga_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  
  signal x_cordic_to_ram : std_logic_vector(9 downto 0) := (others => '0');
  signal y_cordic_to_ram : std_logic_vector(9 downto 0) := (others => '0');

  signal delayed_x : std_logic_vector(9 downto 0) := (others => '0');
  signal delayed_y : std_logic_vector(9 downto 0) := (others => '0');

  signal pixel_to_vga : std_logic_vector(0 downto 0) := (others => '0');
  signal pixel_to_matrix : std_logic_vector(0 downto 0) := (others => '0');

  constant MAX_X : integer := 100;
  constant MAX_Y : integer := 100;
  
  begin

    memory_matrix_0 : memory_matrix
    generic map(CLK_DELAY_COUNT => 0)
    port map(
      x_write => delayed_x,
      y_write => delayed_y,
      write_data => pixel_to_matrix,
      write_enable => '1',
      clk => clk,
      enable => ena,
      reset => rst,
      x_read => x_vga_to_ram,
      y_read => y_vga_to_ram,
      read_data => pixel_to_vga
    );

    vga_controller_0: vga_ctrl
      port map(
        mclk => clk,
        red_i => pixel_to_vga(0),
        grn_i => pixel_to_vga(0),
        blu_i => pixel_to_vga(0),
        hs => hs,
        vs => vs,
        red_o => red_o,
        grn_o => grn_o,
        blu_o => blu_o,
        pixel_row => y_vga_to_ram,
        pixel_col => x_vga_to_ram
    );

    memory_writer_0 : memory_writer
    port map(
      real_x_in => "00000000000000000100000000000000",
      real_y_in => "00000000000000000100000000000000",
      pixel_x_in => delayed_x,
      pixel_y_in => delayed_y,
      pixel_on => pixel_to_matrix
    );

    process(x_vga_to_ram, y_vga_to_ram)
      variable x_i : integer := 0;
      variable y_i : integer := 0;
    begin
      x_i := to_integer(unsigned(x_vga_to_ram));
      y_i := to_integer(unsigned(y_vga_to_ram));
      if(x_i > 0) then
        delayed_x <= std_logic_vector(to_unsigned(x_i - 1,10));
      end if;
      delayed_y <= y_vga_to_ram;

    end process;

end architecture;