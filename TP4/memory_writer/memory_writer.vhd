library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--This component receives the real value of the tip of the vector. Then, for every bit value, it checks if it should be painted or not according to the real value.

entity memory_writer is
	generic(ROWS : integer := 350; COLUMNS : integer := 350; BITS : integer := 32);
	port(
		clk : in std_logic := '0';
		enable : in std_logic := '0';
		rst : in std_logic := '0';
		pixel_x : out std_logic_vector(9 downto 0) := (others => '0');
		pixel_y : out std_logic_vector(9 downto 0) := (others => '0');
		pixel_on : out std_logic_vector(0 downto 0) := (others => '0')
	);

end entity;


architecture memory_writer_arq of memory_writer is
	constant AXIS_X_BIT : std_logic_vector(9 downto 0) := std_logic_vector(shift_right(to_unsigned(COLUMNS,10),1));
	constant AXIS_Y_BIT : std_logic_vector(9 downto 0) := std_logic_vector(shift_right(to_unsigned(ROWS,10),1));

	constant ONE : unsigned(BITS - 1 downto 0) := "00000000000000010000000000000000"; --1.0
	constant PIXEL_COEF : unsigned(BITS - 1 downto 0) := "00000000101011110000000000000000"; --350/2 to account for the displacement by 1

	constant POINTS_LENGTH : integer := 176;

	constant ROTATION_ANGLE : std_logic_vector(31 downto 0) := "00000000000000001011010000000000"; --0.703125 degrees

	signal unrotated_x : std_logic_vector(31 downto 0) := (others => '0');
	signal unrotated_y : std_logic_vector(31 downto 0) := (others => '0');
	
	signal cordic_to_writer_x : std_logic_vector(31 downto 0) := (others => '0');
	signal cordic_to_writer_y : std_logic_vector(31 downto 0) := (others => '0');

	signal rotation_angle_signal : std_logic_vector(31 downto 0) := (others => '0');

	component cordic is
    generic(TOTAL_BITS: integer := 32; STEPS: integer := 16);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
  end component;

begin

	cordic_0 : cordic
    port map(
      x_in => unrotated_x,
      y_in => unrotated_y,
      angle => rotation_angle_signal,
      x_out => cordic_to_writer_x,
      y_out => cordic_to_writer_y
    );

  rotation_angle_signal <= ROTATION_ANGLE;

	
	process(clk, rst)

		variable real_x : std_logic_vector(BITS - 1 downto 0) := (others => '0');
		variable real_y : std_logic_vector(BITS - 1 downto 0) := (others => '0');

		variable moved_x : unsigned(BITS - 1 downto 0) := (others => '0');
		variable moved_y : unsigned(BITS - 1 downto 0) := (others => '0');

		variable extended_moved_x_bit : std_logic_vector(BITS * 2 - 1 downto 0) := (others => '0');
		
		variable extended_moved_y_bit_unsigned : unsigned(BITS * 2 - 1 downto 0) := (others => '0');
		variable truncated_extended_moved_y_bit_unsigned : unsigned(9 downto 0) := (others => '0');
		variable inverted_y_bit : unsigned(9 downto 0) := (others => '0');
		
		variable extended_moved_y_bit : std_logic_vector(BITS * 2 - 1 downto 0) := (others => '0');

		variable moved_x_bit : std_logic_vector(9 downto 0) := (others => '0');
		variable moved_y_bit : std_logic_vector(9 downto 0) := (others => '0');

		variable point_position : integer := 0;

		type real_point is record
			x : std_logic_vector(9 downto 0);
			y : std_logic_vector(9 downto 0);
		end record;
		--  The patterns to apply.
		type on_points_array is array (natural range <>) of real_point;

		variable points_to_draw : on_points_array(0 to 175) := (
					("0000000000","0000000000"),
					("0000000101","0000000000"),
("0000001011","0000000000"),
("0000010001","0000000000"),
("0000010111","0000000000"),
("0000011101","0000000000"),
("0000100011","0000000000"),
("0000101000","0000000000"),
("0000101110","0000000000"),
("0000110100","0000000000"),
("0000111010","0000000000"),
("0001000000","0000000000"),
("0001000110","0000000000"),
("0001001100","0000000000"),
("0001010001","0000000000"),
("0001010111","0000000000"),
("0001011101","0000000000"),
("0001100011","0000000000"),
("0001101001","0000000000"),
("0001101111","0000000000"),
("0001110101","0000000000"),
("0001111010","0000000000"),
("0010000000","0000000000"),
("0010000110","0000000000"),
("0010001100","0000000000"),
("0010010010","0000000000"),
("0010011000","0000000000"),
("0010011101","0000000000"),
("0010100011","0000000000"),
("0010101001","0000000000"),
("0010101111","0000000000"),
("0010110101","0000000000"),
("0010111011","0000000000"),
("0011000001","0000000000"),
("0011000110","0000000000"),
("0011001100","0000000000"),
("0011010010","0000000000"),
("0011011000","0000000000"),
("0011011110","0000000000"),
("0011100100","0000000000"),
("0011101010","0000000000"),
("0011101111","0000000000"),
("0011110101","0000000000"),
("0011111011","0000000000"),
("0100000001","0000000000"),
("0100000111","0000000000"),
("0100001101","0000000000"),
("0100010011","0000000000"),
("0100011000","0000000000"),
("0100011110","0000000000"),
("0100100100","0000000000"),
("0100101010","0000000000"),
("0100110000","0000000000"),
("0100110110","0000000000"),
("0100111011","0000000000"),
("0101000001","0000000000"),
("0101000111","0000000000"),
("0101001101","0000000000"),
("0101010011","0000000000"),
("0101011001","0000000000"),
("0101011111","0000000000"),
("0101100100","0000000000"),
("0101101010","0000000000"),
("0101110000","0000000000"),
("0101110110","0000000000"),
("0101111100","0000000000"),
("0110000010","0000000000"),
("0110001000","0000000000"),
("0110001101","0000000000"),
("0110010011","0000000000"),
("0110011001","0000000000"),
("0110011111","0000000000"),
("0110100101","0000000000"),
("0110101011","0000000000"),
("0110110001","0000000000"),
("0110110110","0000000000"),
("0110111100","0000000000"),
("0111000010","0000000000"),
("0111001000","0000000000"),
("0111001110","0000000000"),
("0111010100","0000000000"),
("0111011001","0000000000"),
("0111011111","0000000000"),
("0111100101","0000000000"),
("0111101011","0000000000"),
("0111110001","0000000000"),
("0111110111","0000000000"),
("0111111101","0000000000"),
("1000000010","0000000000"),
("1000001000","0000000000"),
("1000001110","0000000000"),
("1000010100","0000000000"),
("1000011010","0000000000"),
("1000100000","0000000000"),
("1000100110","0000000000"),
("1000101011","0000000000"),
("1000110001","0000000000"),
("1000110111","0000000000"),
("1000111101","0000000000"),
("1001000011","0000000000"),
("1001001001","0000000000"),
("1001001110","0000000000"),
("1001010100","0000000000"),
("1001011010","0000000000"),
("1001100000","0000000000"),
("1001100110","0000000000"),
("1001101100","0000000000"),
("1001110010","0000000000"),
("1001110111","0000000000"),
("1001111101","0000000000"),
("1010000011","0000000000"),
("1010001001","0000000000"),
("1010001111","0000000000"),
("1010010101","0000000000"),
("1010011011","0000000000"),
("1010100000","0000000000"),
("1010100110","0000000000"),
("1010101100","0000000000"),
("1010110010","0000000000"),
("1010111000","0000000000"),
("1010111110","0000000000"),
("1011000100","0000000000"),
("1011001001","0000000000"),
("1011001111","0000000000"),
("1011010101","0000000000"),
("1011011011","0000000000"),
("1011100001","0000000000"),
("1011100111","0000000000"),
("1011101100","0000000000"),
("1011110010","0000000000"),
("1011111000","0000000000"),
("1011111110","0000000000"),
("1100000100","0000000000"),
("1100001010","0000000000"),
("1100010000","0000000000"),
("1100010101","0000000000"),
("1100011011","0000000000"),
("1100100001","0000000000"),
("1100100111","0000000000"),
("1100101101","0000000000"),
("1100110011","0000000000"),
("1100111001","0000000000"),
("1100111110","0000000000"),
("1101000100","0000000000"),
("1101001010","0000000000"),
("1101010000","0000000000"),
("1101010110","0000000000"),
("1101011100","0000000000"),
("1101100010","0000000000"),
("1101100111","0000000000"),
("1101101101","0000000000"),
("1101110011","0000000000"),
("1101111001","0000000000"),
("1101111111","0000000000"),
("1110000101","0000000000"),
("1110001010","0000000000"),
("1110010000","0000000000"),
("1110010110","0000000000"),
("1110011100","0000000000"),
("1110100010","0000000000"),
("1110101000","0000000000"),
("1110101110","0000000000"),
("1110110011","0000000000"),
("1110111001","0000000000"),
("1110111111","0000000000"),
("1111000101","0000000000"),
("1111001011","0000000000"),
("1111010001","0000000000"),
("1111010111","0000000000"),
("1111011100","0000000000"),
("1111100010","0000000000"),
("1111101000","0000000000"),
("1111101110","0000000000"),
("1111110100","0000000000"),
("1111111010","0000000000"),
("1111111111","0000000000")
				);

			variable rotated_points : on_points_array(0 to 175);
	

	begin

		if(rising_edge(rst)) then --reset values
			point_position := 0;
			pixel_on <= (others => '0');
		end if;
		if(rising_edge(clk)) then

			if(enable = '1') then

				if(point_position < POINTS_LENGTH) then

					--To give time to the cordic to process the data, we shall draw the previous point and in the end set the next point to be processed
					moved_x := unsigned("0000000000000000" & points_to_draw(point_position).x & "000000") + ONE; --Move the x value to the right so that all it's posible locations are a positive number
					moved_y := unsigned("0000000000000000" & points_to_draw(point_position).y & "000000") + ONE; --Move the y value up so that all it's possible locations are a positive number

					extended_moved_x_bit := std_logic_vector(moved_x * PIXEL_COEF); --Compute the pixel location
					moved_x_bit := extended_moved_x_bit(32 + 9 downto 32); --Truncate to integer value
					
					extended_moved_y_bit_unsigned := moved_y * PIXEL_COEF; --Compute the pixel location
					truncated_extended_moved_y_bit_unsigned := extended_moved_y_bit_unsigned(32 + 9 downto 32); --Truncate to integer value
					inverted_y_bit := ROWS - truncated_extended_moved_y_bit_unsigned;
					moved_y_bit := std_logic_vector(inverted_y_bit);

					pixel_x <= moved_x_bit;
					pixel_y <= moved_y_bit;
					pixel_on <= "1";

					--Save the last rotated point and set current to be rotated
					if(point_position > 0) then
						rotated_points(point_position - 1).x := cordic_to_writer_x(15 downto 6);
						rotated_points(point_position - 1).y := cordic_to_writer_y(15 downto 6);
						unrotated_x <= "0000000000000000" & points_to_draw(point_position).x & "000000";
						unrotated_y <= "0000000000000000" & points_to_draw(point_position).y & "000000";
					end if;
					
					point_position := point_position + 1;

				else
					pixel_on <= "0";

					--Move the last point to the rotated points
					rotated_points(point_position - 1).x := cordic_to_writer_x(15 downto 6);
					rotated_points(point_position - 1).y := cordic_to_writer_y(15 downto 6);

					--Switch vectors
					points_to_draw := rotated_points;

				end if;



			end if;

		end if;

	end process;



end memory_writer_arq;