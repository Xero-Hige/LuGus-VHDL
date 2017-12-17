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
    "00000000000000101101000000000000", ---45.0
    "00000000000000011010100100001010", ---26.5649414062
    "00000000000000001110000010010100", ---14.0361328125
    "00000000000000000111001000000000", ---7.125
    "00000000000000000011100100111000", ---3.576171875
    "00000000000000000001110010100011", ---1.78979492188
    "00000000000000000000111001010010", ---0.89501953125
    "00000000000000000000011100101001", ---0.447509765625
    "00000000000000000000001110010100", ---0.2236328125
    "00000000000000000000000111001010", ---0.11181640625
    "00000000000000000000000011100101", ---0.055908203125
    "00000000000000000000000001110010", ---0.02783203125
    "00000000000000000000000000111001", ---0.013916015625
    "00000000000000000000000000011100", ---0.0068359375
    "00000000000000000000000000001110", ---0.00341796875
    "00000000000000000000000000000111"  ---0.001708984375
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