library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component applies CORDIC algorithm with STEPS steps. Keep in mind that the max valid steps is limited by the resolution of
--the fixed point representation and implementation of the angle_step_applier. In this case is 16

entity cordic is
    generic(TOTAL_BITS: integer := 32; STEPS: integer := 16);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );

end cordic;

architecture cordic_arq of cordic is

    constant MAX_STEPS: integer := 16;
    constant ZERO : std_logic_vector(TOTAL_BITS - 1 downto 0 ) := (others => '0');

    type cordic_step is record
        x: std_logic_vector(TOTAL_BITS - 1 downto 0);
        y: std_logic_vector(TOTAL_BITS - 1 downto 0);
        z: std_logic_vector(TOTAL_BITS -1 downto 0);
    end record;
    type cordic_steps_array is array (natural range <>) of cordic_step;
    
    signal cordic_steps : cordic_steps_array(STEPS downto 0);
    signal normalized_x : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
    signal normalized_y : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
    
    component angle_step_applier is
        generic(TOTAL_BITS: integer := 32);
        port(
          x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          z_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          step_index : in integer := 0;
          x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          z_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
        );
    end component;

    component normalizer is
        generic(TOTAL_BITS: integer := 32);
        port(
          x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          steps_applied : in integer := 0;
          x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
          y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
        );
    end component;

    begin

        cordic_steps(0).x <= x_in;
        cordic_steps(0).y <= y_in;
        cordic_steps(0).z <= angle;

        all_steps: for i in 0 to (STEPS - 1) generate
                step :  angle_step_applier
                        generic map(TOTAL_BITS => TOTAL_BITS)
                        port map(
                            x_in => cordic_steps(i).x,
                            y_in => cordic_steps(i).y,
                            z_in => cordic_steps(i).z,
                            step_index => i,
                            x_out => cordic_steps(i+1).x,
                            y_out => cordic_steps(i+1).y,
                            z_out => cordic_steps(i+1).z
                        );
            end generate all_steps;

        normalizer_0 : normalizer
        generic map(TOTAL_BITS => TOTAL_BITS)
        port map(
            x_in => cordic_steps(STEPS).x,
            y_in => cordic_steps(STEPS).y,
            steps_applied => STEPS,
            x_out => normalized_x,
            y_out => normalized_y
        );

        x_out <= normalized_x when angle /= ZERO else x_in;
        y_out <= normalized_y when angle /= ZERO else y_in;



end architecture;