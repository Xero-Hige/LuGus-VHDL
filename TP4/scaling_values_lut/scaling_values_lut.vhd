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

  constant max_representable_value_index: integer := 5; --After this index, the fixed point representation can't show any difference

  type scaling_values_table is array (natural range <>) of std_logic_vector(TOTAL_BITS - 1 downto 0);
  constant scaling_values : scaling_values_table := (
    "00000000000000000000101101010000", ---0.70703125
    "00000000000000000000101000011110", ---0.63232421875
    "00000000000000000000100111010001", ---0.613525390625
    "00000000000000000000100110111101", ---0.608642578125
    "00000000000000000000100110111000", ---0.607421875
    "00000000000000000000100110110111" ---0.607177734375
  );

  begin
    process (steps) is
      begin
		    if(steps > max_representable_value_index) then
          scaling_value <= scaling_values(max_representable_value_index);
        elsif(steps = 0) then
          scaling_value <= (others => '0');
        else
          scaling_value <= scaling_values(steps - 1);
        end if;
    end process;
end architecture;