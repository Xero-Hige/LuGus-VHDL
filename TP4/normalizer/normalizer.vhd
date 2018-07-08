library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component normalizes the vector components according to the steps used in cordic algorithm

entity normalizer is
    generic(TOTAL_BITS: integer := 32; FRACTIONAL_BITS: integer := 16);
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
            variable x_signed : signed(TOTAL_BITS - 1 downto 0) := (others => '0');
            variable y_signed : signed(TOTAL_BITS - 1 downto 0) := (others => '0');
            variable scaling_value_signed : signed(TOTAL_BITS - 1 downto 0) := (others => '0');
            variable scaled_x : signed(TOTAL_BITS * 2 - 1 downto 0) := (others => '0');
            variable scaled_y : signed(TOTAL_BITS * 2 - 1 downto 0) := (others => '0');
            variable shifted_x : signed(TOTAL_BITS * 2 - 1 downto 0) := (others => '0');
            variable shifted_y : signed(TOTAL_BITS * 2 - 1 downto 0) := (others => '0');
		begin

            lut_index <= steps_applied;

            x_signed := signed(x_in);
            y_signed := signed(y_in);
            scaling_value_signed := signed(scaling_values_lut_value);

            scaled_x := x_signed * scaling_value_signed;
            scaled_y := y_signed * scaling_value_signed;

            shifted_x := shift_right(scaled_x,FRACTIONAL_BITS);
            shifted_y := shift_right(scaled_y,FRACTIONAL_BITS);

            x_out <= std_logic_vector(shifted_x(TOTAL_BITS - 1 downto 0));
            y_out <= std_logic_vector(shifted_y(TOTAL_BITS - 1 downto 0));

        end process;

end architecture;
