library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_matrix is
    generic(ROWS: integer := 350; COLUMNS: integer := 350);
    port(
      x_write: in std_logic_vector(8 downto 0) := (others => '0');
      y_write: in std_logic_vector(8 downto 0) := (others => '0');
      write_data: in std_logic_vector(0 downto 0) := (others => '0');
      write_enable: in std_logic := '0';
      
      clk: in std_logic := '0';
      enable: in std_logic := '0';
      reset: in std_logic := '0';

      x_read: in std_logic_vector(8 downto 0) := (others => '0');
      y_read: in std_logic_vector(8 downto 0) := (others => '0');
      read_data : out std_logic_vector(0 downto 0) := (others => '0')
    );

end memory_matrix;

architecture memory_matrix_arq of memory_matrix is

    constant MAX_ROWS : integer := 350;
    constant MAX_COLUMNS : integer := 350;

    constant RAM_SIZE : integer := 16384;
    constant RAM_SIZE_1 : integer := 2 * RAM_SIZE;
    constant RAM_SIZE_2 : integer := 3 * RAM_SIZE;
    constant RAM_SIZE_3 : integer := 4 * RAM_SIZE;
    constant RAM_SIZE_4 : integer := 5 * RAM_SIZE;
    constant RAM_SIZE_5 : integer := 6 * RAM_SIZE;
    constant RAM_SIZE_6 : integer := 7 * RAM_SIZE;
    constant RAM_SIZE_7 : integer := 8 * RAM_SIZE;

    signal memory_enable : std_logic := '0';
    signal write_address : std_logic_vector(13 downto 0) := (others => '0');
    signal read_address : std_logic_vector(13 downto 0) := (others => '0');
    signal ram_write_mask : std_logic_vector(7 downto 0) := (others => '0');
    signal ram_read_mask : std_logic_vector(7 downto 0) := (others => '0');
    
    component dual_port_ram is
    port (
      data_in : in std_logic_vector (0 downto 0) := (others => '0');
      write_address : in std_logic_vector (13 downto 0) := (others => '0');
      write_enable : in std_logic := '0';
      ram_write_mask : in std_logic_vector(7 downto 0) := (others => '0');
      
      enable : in std_logic := '0';
      clk : in std_logic := '0';
      reset : in std_logic := '0';

      ram_read_mask : in std_logic_vector(7 downto 0) := (others => '0');
      read_address : in std_logic_vector(13 downto 0) := (others => '0');
      data_out : out std_logic_vector (0 downto 0) := (others => '0')

    );
    end component;

    component enable_generator is

    generic(CYCLE_COUNT: integer := 10);
    port(
      clk: in std_logic := '0';
      enable_in: in std_logic := '0';
      enable_out : out std_logic := '0'
    );
    end component;


    begin

      dual_port_ram_0 : dual_port_ram
      port map(
        data_in => write_data,
        write_address => write_address,
        write_enable => write_enable,
        ram_write_mask => ram_write_mask,
        enable => memory_enable,
        reset => reset,
        clk => clk,
        ram_read_mask => ram_read_mask,
        read_address => read_address,
        data_out => read_data
      );

      enable_generator_0 : enable_generator
      generic map(CYCLE_COUNT => 9)
      port map(
        clk => clk,
        enable_in => enable,
        enable_out => memory_enable
      );

    process(enable, reset, write_enable,write_data, x_read, x_write, y_read, y_write)
      variable x_read_int : integer := 0;
      variable y_read_int : integer := 0; 
      variable x_write_int : integer := 0;
      variable y_write_int : integer := 0;
      variable tmp_read_ram : integer := 0;
      variable tmp_write_ram : integer := 0;
      variable read_bit_position : integer := 0;
      variable write_bit_position : integer := 0;
      variable read_pos_in_ram : integer := 0;
      variable write_pos_in_ram : integer := 0;
      variable default_ram_mask : unsigned(7 downto 0) := "00000001";

    begin
      x_read_int := to_integer(unsigned(x_read));
      y_read_int := to_integer(unsigned(y_read));
      x_write_int := to_integer(unsigned(x_write));
      y_write_int := to_integer(unsigned(y_write));

      if(ROWS > MAX_ROWS) then
        report "MAX ROWS is: " & integer'image(MAX_ROWS) severity failure;
      end if;
      if(COLUMNS > MAX_COLUMNS) then
        report "MAX COLUMNS is: " & integer'image(MAX_COLUMNS) severity failure;
      end if;
      if(x_read_int >= COLUMNS or x_write_int >= COLUMNS) then
        report "MAX X is: " & integer'image(COLUMNS - 1) severity failure;
      end if;
      if(y_read_int >= ROWS or y_write_int >= ROWS) then
        report "MAX Y is: " & integer'image(ROWS - 1) severity failure;
      end if;

      read_bit_position := x_read_int + y_read_int * COLUMNS;
      case (read_bit_position) is
        when 0 to RAM_SIZE-1 => tmp_read_ram := 0;
        when RAM_SIZE to RAM_SIZE_1-1 => tmp_read_ram := 1;
        when RAM_SIZE_1 to RAM_SIZE_2-1 => tmp_read_ram := 2;
        when RAM_SIZE_2 to RAM_SIZE_3-1 => tmp_read_ram := 3;
        when RAM_SIZE_3 to RAM_SIZE_4-1 => tmp_read_ram := 4;
        when RAM_SIZE_4 to RAM_SIZE_5-1 => tmp_read_ram := 5;
        when RAM_SIZE_5 to RAM_SIZE_6-1 => tmp_read_ram := 6;
        when RAM_SIZE_6 to RAM_SIZE_7-1 => tmp_read_ram := 7;
        when others => tmp_read_ram := 0;
      end case;

      write_bit_position := x_write_int + y_write_int  * ROWS;
      case (write_bit_position) is
        when 0 to RAM_SIZE-1 => tmp_write_ram := 0;
        when RAM_SIZE to RAM_SIZE_1-1 => tmp_write_ram := 1;
        when RAM_SIZE_1 to RAM_SIZE_2-1 => tmp_write_ram := 2;
        when RAM_SIZE_2 to RAM_SIZE_3-1 => tmp_write_ram := 3;
        when RAM_SIZE_3 to RAM_SIZE_4-1 => tmp_write_ram := 4;
        when RAM_SIZE_4 to RAM_SIZE_5-1 => tmp_write_ram := 5;
        when RAM_SIZE_5 to RAM_SIZE_6-1 => tmp_write_ram := 6;
        when RAM_SIZE_6 to RAM_SIZE_7-1 => tmp_write_ram := 7;
        when others => tmp_read_ram := 0;
      end case;

      --report "X READ: " & integer'image(x_read_int);
      --report "Y READ: " & integer'image(y_read_int);
      --report "X WRITE: " & integer'image(x_write_int);
      --report "Y WRITE: " & integer'image(y_write_int);
      --report "READ BIT POS: " & integer'image(read_bit_position);
      --report "WRITE BIT POS: " & integer'image(write_bit_position);
      --report "WRITE RAM: " & integer'image(tmp_write_ram);
      --report "READ RAM: " & integer'image(tmp_read_ram);
      
      read_pos_in_ram := read_bit_position - (tmp_read_ram * RAM_SIZE);
      write_pos_in_ram := write_bit_position - (tmp_write_ram * RAM_SIZE);

      --report "READ POS IN RAM: " & integer'image(read_pos_in_ram);
      --report "WRITE POS IN RAM: " & integer'image(write_pos_in_ram);

      read_address <= std_logic_vector(to_unsigned(read_pos_in_ram,14));
      write_address <= std_logic_vector(to_unsigned(write_pos_in_ram, 14));

      ram_read_mask <= std_logic_vector(shift_left(default_ram_mask, tmp_read_ram));
      ram_write_mask <= std_logic_vector(shift_left(default_ram_mask, tmp_write_ram));

      --report "READ MASK: " & integer'image(to_integer(unsigned(ram_read_mask)));
      --report "WRITE MASK: " & integer'image(to_integer(unsigned(ram_write_mask)));

    end process;

end architecture;