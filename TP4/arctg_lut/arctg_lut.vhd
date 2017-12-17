library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Lookup table for the arctg values according to the step index of the CORDIC execution.

entity arctg_lut is
  generic(TOTAL_BITS: integer := 32);
  port(
    step_index: in integer := 0;
    angle: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
  );

end arctg_lut;

architecture arctg_lut_arq of arctg_lut is

  constant max_index: integer := 15;

  type arctgs_table is array (natural range <>) of std_logic_vector(TOTAL_BITS - 1 downto 0);
  constant arctgs : arctgs_table := (
    "00000000001011010000000000000000", ---45.0
    "00000000000110101001000010100111", ---26.5650482178
    "00000000000011100000100101000111", ---14.036239624
    "00000000000001110010000000000001", ---7.12501525879
    "00000000000000111001001110001010", ---3.57632446289
    "00000000000000011100101000110111", ---1.7899017334
    "00000000000000001110010100101010", ---0.895172119141
    "00000000000000000111001010010110", ---0.447601318359
    "00000000000000000011100101001011", ---0.22380065918
    "00000000000000000001110010100101", ---0.111892700195
    "00000000000000000000111001010010", ---0.0559387207031
    "00000000000000000000011100101001", ---0.0279693603516
    "00000000000000000000001110010100", ---0.0139770507812
    "00000000000000000000000111001010", ---0.00698852539062
    "00000000000000000000000011100101", ---0.00349426269531
    "00000000000000000000000001110010"  ---0.00173950195312
  );

  begin
    process (step_index) is
      begin
		    if(step_index > max_index) then
          report "STEP NOT ALLOWED!!!" severity failure;
        else
          angle <= arctgs(step_index);
        end if;
    end process;
end architecture;