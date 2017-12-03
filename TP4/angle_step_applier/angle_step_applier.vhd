library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component applies a step of the CORDIC algorithm acording to the accumulated angle.

entity angle_step_applier is
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

end angle_step_applier;

architecture angle_step_applier_arq of angle_step_applier is

    signal lut_index : integer := 0;
    signal arctg_lut_angle : std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
    
    component arctg_lut is
        generic(TOTAL_BITS: integer := 32);
        port(
            step_index: in integer := 0;
            angle: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0') 
        );
    end component;

    for arctg_lut_0 : arctg_lut use entity work.arctg_lut;

    begin

        arctg_lut_0 : arctg_lut
            generic map(TOTAL_BITS => 32)
            port map(
                step_index  => lut_index,
                angle  => arctg_lut_angle
            );

    	process (x_in, y_in, z_in, step_index, lut_index, arctg_lut_angle) is
    		variable angle_offset : integer := 0;
            variable z_integer : integer := 0;
            variable d : integer := 0;
		begin

            lut_index <= step_index;
            z_integer := to_integer(signed(z_in));

            if(z_integer > 0) then
                d := -1;
            elsif(z_integer < 0) then
                d := 1;
            else
                d := 0;
            end if;

            angle_offset := to_integer(signed(arctg_lut_angle)) * d;

            z_out <= std_logic_vector(to_signed(z_integer + angle_offset, TOTAL_BITS));
            x_out <= x_in;
            y_out <= y_in;

        end process;

end architecture;