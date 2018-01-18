-- Module: XC3S_RAMB_1_PORT
-- Description: 18Kb Block SelectRAM example
-- Single Port 512 x 36 bits
-- Use template "SelectRAM_A36.vhd"
--
-- Device: Spartan-3 Family
---------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
--
-- Syntax for Synopsys FPGA Express
-- pragma translate_off
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
-- pragma translate_on
--
entity dual_port_ram is
  port (
    data_in : in std_logic_vector (0 downto 0) := (others => '0');
    sub_ram : in std_logic_vector(7 downto 0) := (others => '0');
    address : in std_logic_vector (13 downto 0) := (others => '0');
    enable : in std_logic := '0';
    clk : in std_logic := '0';
    write_enable : in std_logic := '0';
    reset : in std_logic := '0';
    data_out : out std_logic_vector (0 downto 0) := (others => '0')
  );
end dual_port_ram;
--
architecture dual_port_ram_arq of dual_port_ram is
  
  signal clk_signal : std_logic := '0';

  signal enable_0 : std_logic := '0';
  signal enable_1 : std_logic := '0';
  signal enable_2 : std_logic := '0';
  signal enable_3 : std_logic := '0';
  signal enable_4 : std_logic := '0';
  signal enable_5 : std_logic := '0';
  signal enable_6 : std_logic := '0';
  signal enable_7 : std_logic := '0';

  signal data_out_0 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_1 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_2 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_3 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_4 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_5 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_6 : std_logic_vector(0 downto 0) := (others => '0'); 
  signal data_out_7 : std_logic_vector(0 downto 0) := (others => '0'); 
  

   --Syntax for Synopsys FPGA Express
  component RAMB16_S1
   --pragma translate_off
    generic (
      -- "Read during Write" attribute for functional simulation
      WRITE_MODE : string := "READ_FIRST" -- WRITE_FIRST(default)/ READ_FIRST/ NO_CHANGE
    );
    -- pragma translate_on
    port(
      DO : out STD_LOGIC_VECTOR (0 downto 0);
      ADDR : in STD_LOGIC_VECTOR (13 downto 0);
      CLK : in STD_ULOGIC;
      DI : in STD_LOGIC_VECTOR (0 downto 0);
      EN : in STD_ULOGIC;
      SSR : in STD_ULOGIC;
      WE : in STD_ULOGIC
    );
  end component;

  for ram_0 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_1 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_2 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_3 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_4 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_5 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_6 : RAMB16_S1 use entity unisim.RAMB16_S1;
  for ram_7 : RAMB16_S1 use entity unisim.RAMB16_S1;

  --
  begin

    -- Block SelectRAM Instantiation
    ram_0: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_0,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_0
    );

    -- Block SelectRAM Instantiation
    ram_1: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_1,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_1
    );

    -- Block SelectRAM Instantiation
    ram_2: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_2,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_2
    );

    -- Block SelectRAM Instantiation
    ram_3: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_3,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_3
    );

    -- Block SelectRAM Instantiation
    ram_4: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_4,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_4
    );


    -- Block SelectRAM Instantiation
    ram_5: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_5,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_5
    );


    -- Block SelectRAM Instantiation
    ram_6: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_6,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_6
    );


    -- Block SelectRAM Instantiation
    ram_7: RAMB16_S1
    port map (
      DI => data_in,
      ADDR => address,
      EN => enable_7,
      WE => write_enable,
      SSR => reset,
      CLK => clk_signal,
      DO => data_out_7
    );

    enable_0 <= enable and sub_ram(0);
    enable_1 <= enable and sub_ram(1);
    enable_2 <= enable and sub_ram(2);
    enable_3 <= enable and sub_ram(3);
    enable_4 <= enable and sub_ram(4);
    enable_5 <= enable and sub_ram(5);
    enable_6 <= enable and sub_ram(6);
    enable_7 <= enable and sub_ram(7);
    data_out(0) <= (data_out_0(0) and sub_ram(0)) or (data_out_1(0) and sub_ram(1)) or (data_out_2(0) and sub_ram(2)) or (data_out_3(0) and sub_ram(3)) or (data_out_4(0) and sub_ram(4)) or (data_out_5(0) and sub_ram(5)) or (data_out_6(0) and sub_ram(6)) or (data_out_7(0) and sub_ram(7));


    process(data_in, clk, enable, address)
    begin
      clk_signal <= clk;
    end process;

--
end dual_port_ram_arq;