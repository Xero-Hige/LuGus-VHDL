-- Module: XC3S_RAMB_1_PORT
-- Description: 18Kb Block SelectRAM example
-- Single Port 512 x 36 bits
-- Use template "SelectRAM_A36.vhd"
--
-- Device: Spartan-3 Family
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--
-- Syntax for Synopsys FPGA Express
-- pragma translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- pragma translate_on
--
entity dual_port_ram is
  port (
    DATA_IN : in std_logic_vector (35 downto 0) := (others => '0');
    ADDRESS : in std_logic_vector (8 downto 0) := (others => '0');
    ENABLE : in std_logic := '0';
    WRITE_EN : in std_logic := '0';
    SET_RESET : in std_logic := '0';
    CLK : in std_logic := '0';
    DATA_OUT : out std_logic_vector (35 downto 0) := (others => '0')
  );
end dual_port_ram;
--
architecture dual_port_ram_arq of dual_port_ram is
  --
  -- Components Declarations:
  --
  --component BUFG
  --  port (
  --    O : out std_ulogic;

  --    I : in std_ulogic
  --  );
  --end component;
  --
  -- Syntax for Synopsys FPGA Express
  --component RAMB16_S36
  -- --pragma translate_off
  --  generic (
  --    -- "Read during Write" attribute for functional simulation
  --    WRITE_MODE : string := "READ_FIRST" ; -- WRITE_FIRST(default)/ READ_FIRST/ NO_CHANGE
  --    -- Output value after configuration
  --    INIT : bit_vector(35 downto 0) := X"000000000";
  --    -- Output value if SSR active
  --    SRVAL : bit_vector(35 downto 0) := X"012345678";
  --    -- Initialize parity memory content
  --    INITP_00 : bit_vector(255 downto 0) :=
  --    X"000000000000000000000000000000000000000000000000FEDCBA9876543210";
  --    INITP_01 : bit_vector(255 downto 0) :=
  --    X"0000000000000000000000000000000000000000000000000000000000000000";

  --    INITP_07 : bit_vector(255 downto 0) :=
  --    X"0000000000000000000000000000000000000000000000000000000000000000";
  --    -- Initialize data memory content
  --    INIT_00 : bit_vector(255 downto 0) :=
  --    X"000000000000000000000000000000000000000000000000FEDCBA9876543210";
  --    INIT_01 : bit_vector(255 downto 0) :=
  --    X"0000000000000000000000000000000000000000000000000000000000000000";
  --    INIT_3F : bit_vector(255 downto 0) :=
  --    X"0000000000000000000000000000000000000000000000000000000000000000"
  --  );
  --  -- pragma translate_on
  --  port (
  --    DI : in std_logic_vector (31 downto 0);
  --    DIP : in std_logic_vector (3 downto 0);
  --    ADDR : in std_logic_vector (8 downto 0);
  --    EN : in STD_LOGIC;
  --    WE : in STD_LOGIC;
  --    SSR : in STD_LOGIC;
  --    CLK : in STD_LOGIC;
  --    DO : out std_logic_vector (31 downto 0);
  --    DOP : out std_logic_vector (3 downto 0)
  --  );
  --end component;
  --
  -- Attribute Declarations:
  attribute WRITE_MODE : string;
  attribute INIT: string;
  attribute SRVAL: string;
  -- Parity memory initialization attributes
  attribute INITP_00: string;
  attribute INITP_01: string;

  attribute INITP_07: string;
  -- Data memory initialization attributes
  attribute INIT_00: string;
  attribute INIT_01: string;

  attribute INIT_3F: string;
  --
  -- Attribute "Read during Write mode" = WRITE_FIRST(default)/ READ_FIRST/ NO_CHANGE
  --attribute WRITE_MODE of U_RAMB16_S36: label is "READ_FIRST";
  --attribute INIT of U_RAMB16_S36: label is "000000000";
  --attribute SRVAL of U_RAMB16_S36: label is "012345678";
  --
  -- RAMB16 memory initialization for Alliance
  -- Default value is "0" / Partial initialization strings are padded
  -- with zeros to the left
  --attribute INITP_00 of U_RAMB16_S36: label is
  --"000000000000000000000000000000000000000000000000FEDCBA9876543210";
  --attribute INITP_01 of U_RAMB16_S36: label is
  --"0000000000000000000000000000000000000000000000000000000000000000";
  
  --attribute INITP_07 of U_RAMB16_S36: label is
  --"0000000000000000000000000000000000000000000000000000000000000000";
  ----
  --attribute INIT_00 of U_RAMB16_S36: label is
  --"000000000000000000000000000000000000000000000000FEDCBA9876543210";
  --attribute INIT_01 of U_RAMB16_S36: label is
  --"0000000000000000000000000000000000000000000000000000000000000000";
  
  --attribute INIT_3F of U_RAMB16_S36: label is
  --"0000000000000000000000000000000000000000000000000000000000000000";
  --
  -- Signal Declarations:
  --
  -- signal VCC : std_logic;
  -- signal GND : std_logic;
  signal CLK_BUFG: std_logic;
  signal INV_SET_RESET : std_logic;
  --
  begin
  -- VCC <= '1';
  -- GND <= '0';
  --
  -- Instantiate the clock Buffer
    U_BUFG: BUFG
    port map (
      I => CLK,
      O => CLK_BUFG
    );
  --
  -- Use of the free inverter on SSR pin
  INV_SET_RESET <= NOT SET_RESET;
  -- Block SelectRAM Instantiation
  U_RAMB16_S36: RAMB16_S36
  port map (
    DI => DATA_IN (31 downto 0), -- insert 32 bits data-in bus (<31 downto 0>)
    DIP => DATA_IN (35 downto 32), -- insert 4 bits parity data-in bus (or <35
    -- downto 32>)
    ADDR => ADDRESS (8 downto 0), -- insert 9 bits address bus
    EN => ENABLE, -- insert enable signal
    WE => WRITE_EN, -- insert write enable signal
    SSR => INV_SET_RESET, -- insert set/reset signal
    CLK => CLK_BUFG, -- insert clock signal
    DO => DATA_OUT (31 downto 0), -- insert 32 bits data-out bus (<31 downto 0>)
    DOP => DATA_OUT (35 downto 32) -- insert 4 bits parity data-out bus (or <35
  -- downto 32>)
  );
--
end dual_port_ram_arq;