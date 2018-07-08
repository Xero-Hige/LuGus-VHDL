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
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
--
entity dual_port_ram is
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
end dual_port_ram;
--
architecture dual_port_ram_arq of dual_port_ram is

  signal clk_signal : std_logic := '0';

  signal read_enable_0 : std_logic := '0';
  signal write_enable_0 : std_logic := '0';
  signal read_enable_1 : std_logic := '0';
  signal write_enable_1 : std_logic := '0';
  signal read_enable_2 : std_logic := '0';
  signal write_enable_2 : std_logic := '0';
  signal read_enable_3 : std_logic := '0';
  signal write_enable_3 : std_logic := '0';
  signal read_enable_4 : std_logic := '0';
  signal write_enable_4 : std_logic := '0';
  signal read_enable_5 : std_logic := '0';
  signal write_enable_5 : std_logic := '0';
  signal read_enable_6 : std_logic := '0';
  signal write_enable_6 : std_logic := '0';
  signal read_enable_7 : std_logic := '0';
  signal write_enable_7 : std_logic := '0';

  signal data_out_0 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_1 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_2 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_3 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_4 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_5 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_6 : std_logic_vector(0 downto 0) := (others => '0');
  signal data_out_7 : std_logic_vector(0 downto 0) := (others => '0');

  --
  begin

    -- Block SelectRAM Instantiation
    ram_0: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_0,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_0,
      ENB  => read_enable_0,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_1: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_1,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_1,
      ENB  => read_enable_1,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_2: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_2,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_2,
      ENB  => read_enable_2,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_3: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_3,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_3,
      ENB  => read_enable_3,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_4: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_4,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_4,
      ENB  => read_enable_4,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );


    ram_5: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_5,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_5,
      ENB  => read_enable_5,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_6: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_6,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_6,
      ENB  => read_enable_6,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    ram_7: RAMB16_S1_S1
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => data_out_7,
      ADDRA => write_address,
      ADDRB => read_address,
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => data_in,
      DIB  => "0",
      ENA  => write_enable_7,
      ENB  => read_enable_7,
      SSRA  => '0',
      SSRB => '0',
      WEA  => write_enable,
      WEB  => '0' --will write 0 after read
    );

    read_enable_0 <= enable and ram_read_mask(0);
    write_enable_0 <= enable and ram_write_mask(0);
    read_enable_1 <= enable and ram_read_mask(1);
    write_enable_1 <= enable and ram_write_mask(1);
    read_enable_2 <= enable and ram_read_mask(2);
    write_enable_2 <= enable and ram_write_mask(2);
    read_enable_3 <= enable and ram_read_mask(3);
    write_enable_3 <= enable and ram_write_mask(3);
    read_enable_4 <= enable and ram_read_mask(4);
    write_enable_4 <= enable and ram_write_mask(4);
    read_enable_5 <= enable and ram_read_mask(5);
    write_enable_5 <= enable and ram_write_mask(5);
    read_enable_6 <= enable and ram_read_mask(6);
    write_enable_6 <= enable and ram_write_mask(6);
    read_enable_7 <= enable and ram_read_mask(7);
    write_enable_7 <= enable and ram_write_mask(7);

    clk_signal <= clk;

    data_out(0) <= (data_out_0(0) and ram_read_mask(0)) or (data_out_1(0) and ram_read_mask(1)) or (data_out_2(0) and ram_read_mask(2)) or (data_out_3(0) and ram_read_mask(3)) or (data_out_4(0) and ram_read_mask(4)) or (data_out_5(0) and ram_read_mask(5)) or (data_out_6(0) and ram_read_mask(6)) or (data_out_7(0) and ram_read_mask(7));

end dual_port_ram_arq;
