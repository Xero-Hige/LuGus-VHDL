library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component add or substracts a fixed value from the coordenates to rotate them before applying cordic

entity preprocessor is
    generic(TOTAL_BITS: integer := 32);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_in : in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );

end preprocessor;

architecture preprocessor_arq of preprocessor is

    begin

    	process (x_in, y_in, angle_in) is
            variable angle_int : integer := 0;
            variable x_int : integer := 0;
            variable y_int : integer := 0;
            variable tmp_int: integer := 0;
		begin
            angle_int := to_integer(signed(angle_in));
            x_int := to_integer(signed(x_in)); 
            y_int := to_integer(signed(y_in));

            if(angle_int > 180) then
                angle_int := angle_int - 360;
            elsif (angle_int < -180) then
                angle_int := 360 + angle_int;
            end if;
                

            if(angle_int > 90) then
                tmp_int := x_int;
                x_int := -y_int;
                y_int := tmp_int;
                angle_int := angle_int - 90;
            elsif(angle_int < -90) then
                tmp_int := y_int;
                y_int := -x_int;
                x_int := tmp_int;
                angle_int := angle_int + 90;

            end if;

            angle_out <= std_logic_vector(to_signed(angle_int,TOTAL_BITS));
            x_out <= std_logic_vector(to_signed(x_int,TOTAL_BITS));
            y_out <= std_logic_vector(to_signed(y_int,TOTAL_BITS));

        end process;

end architecture;