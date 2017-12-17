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
    "00000000000000001011010100000100", ---0.707092285156
    "00000000000000001010000111101000", ---0.632446289062
    "00000000000000001001110100010011", ---0.613571166992
    "00000000000000001001101111011100", ---0.608825683594
    "00000000000000001001101110001110", ---0.607635498047
    "00000000000000001001101101111011", ---0.607345581055
    "00000000000000001001101101110110", ---0.607269287109
    "00000000000000001001101101110101", ---0.60725402832
    "00000000000000001001101101110101", ---0.60725402832
    "00000000000000001001101101110100" ---0.607238769531
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