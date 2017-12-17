library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component normalizes the vector components according to the steps used in cordic algorithm

entity normalizer is
    generic(TOTAL_BITS: integer := 32; FRACTIONAL_BITS: integer := 12);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      steps_applied : in integer := 0;
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );

end normalizer;

architecture normalizer_arq of normalizer is

    signal lut_index : integer := 0;
    signal scaling_values_lut_value : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
    
    component scaling_values_lut is
        generic(TOTAL_BITS: integer := 32);
          port(
            steps: in integer := 0;
            scaling_value: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
          );
    end component;

    begin

        scaling_values_lut_0 : scaling_values_lut
            generic map(TOTAL_BITS => 32)
            port map(
                steps => lut_index,
                scaling_value => scaling_values_lut_value
            );

    	process (x_in, y_in, steps_applied, lut_index, scaling_values_lut_value) is
            variable x_integer : integer := 0;
            variable y_integer : integer := 0;
            variable scaling_value_integer : integer := 0;
            variable scaled_x : integer := 0;
            variable scaled_y : integer := 0;
		begin

            lut_index <= steps_applied;

            x_integer := to_integer(signed(x_in));
            y_integer := to_integer(signed(y_in));
            scaling_value_integer := to_integer(signed(scaling_values_lut_value));

            report "X: " & integer'image(x_integer);
            report "Y: " & integer'image(y_integer);
            report "SV: " & integer'image(scaling_value_integer);

        
            scaled_x := x_integer * scaling_value_integer;
            scaled_y := y_integer * scaling_value_integer;
             
            report "AFTER";

            x_out <= std_logic_vector(shift_right(to_signed(scaled_x, TOTAL_BITS),FRACTIONAL_BITS));
            y_out <= std_logic_vector(shift_right(to_signed(scaled_y, TOTAL_BITS),FRACTIONAL_BITS));


        end process;

end architecture;