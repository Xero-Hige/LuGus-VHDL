library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Lookup table for scaling values to apply to the vector after rotating. It depends on the number of steps of the algorithm

entity scaling_values_lut is
  generic(TOTAL_BITS: integer := 32);
  port(
    steps: in integer := 0;
    scaling_value: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
  );

end scaling_values_lut;

architecture scaling_values_lut_arq of scaling_values_lut is

  constant max_representable_value_index: integer := 9; --After this index, the fixed point representation can't show any difference

  type scaling_values_table is array (natural range <>) of std_logic_vector(TOTAL_BITS - 1 downto 0);
  constant scaling_values : scaling_values_table := (
    "00000000000000010110101000001001",     --1.4141998291
    "00000000000000011001010011000101",     --1.58113098145
    "00000000000000011010000100111010",     --1.62979125977
    "00000000000000011010010001111001",     --1.64247131348
    "00000000000000011010010101001011",     --1.64567565918
    "00000000000000011010010110000000",     --1.646484375
    "00000000000000011010010110001101",     --1.64668273926
    "00000000000000011010010110010000",     --1.64672851562
    "00000000000000011010010110010001",     --1.64674377441
    "00000000000000011010010110010010"      --1.6467590332
  );

  begin
    process (steps) is
      begin
		    if(steps > max_representable_value_index) then
          scaling_value <= scaling_values(max_representable_value_index);
        else
          scaling_value <= scaling_values(steps);
        end if;
    end process;
end architecture;