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
		real_x_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
		real_y_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
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

	signal rotating_point_x : std_logic_vector(9 downto 0) := (others => '0');
	signal rotating_point_y : std_logic_vector(9 downto 0) := (others => '0');

begin
	

	--Compute the position of the point in the pixel grid and set values to then be able to write to ram
	process(real_x_in, real_y_in)
		variable moved_x : unsigned(BITS - 1 downto 0) := (others => '0');
		variable moved_y : unsigned(BITS - 1 downto 0) := (others => '0');

		variable extended_moved_x_bit : std_logic_vector(BITS * 2 - 1 downto 0) := (others => '0');
		
		variable extended_moved_y_bit_unsigned : unsigned(BITS * 2 - 1 downto 0) := (others => '0');
		variable truncated_extended_moved_y_bit_unsigned : unsigned(9 downto 0) := (others => '0');
		variable inverted_y_bit : unsigned(9 downto 0) := (others => '0');
		
		variable extended_moved_y_bit : std_logic_vector(BITS * 2 - 1 downto 0) := (others => '0');

		variable moved_x_bit : std_logic_vector(9 downto 0) := (others => '0');
		variable moved_y_bit : std_logic_vector(9 downto 0) := (others => '0');

	begin
		moved_x := unsigned(real_x_in) + ONE; --Move the x value to the right so that all it's posible locations are a positive number
		moved_y := unsigned(real_y_in) + ONE; --Move the y value up so that all it's possible locations are a positive number

		extended_moved_x_bit := std_logic_vector(moved_x * PIXEL_COEF); --Compute the pixel location
		moved_x_bit := extended_moved_x_bit(32 + 9 downto 32); --Truncate to integer value
		
		extended_moved_y_bit_unsigned := moved_y * PIXEL_COEF; --Compute the pixel location
		truncated_extended_moved_y_bit_unsigned := extended_moved_y_bit_unsigned(32 + 9 downto 32); --Truncate to integer value
		inverted_y_bit := ROWS - truncated_extended_moved_y_bit_unsigned;
		moved_y_bit := std_logic_vector(inverted_y_bit);


		rotating_point_x <= moved_x_bit;
		rotating_point_y <= moved_y_bit;

	end process;

	process(clk,rst)

		variable x_pos : integer := 0;
		variable y_pos : integer := 0;

		variable x_pos_vector : std_logic_vector(9 downto 0) := (others => '0');
		variable y_pos_vector : std_logic_vector(9 downto 0) := (others => '0');

	begin
		if(rising_edge(rst)) then --reset values
			x_pos := 0;
			y_pos := 0;
		end if;

		if(rising_edge(clk)) then

			if(enable = '1') then
				if(y_pos < ROWS) then --If this condition is not met means that the screen is already fully painted and we need to wait until a resset.

					x_pos_vector := std_logic_vector(to_unsigned(x_pos,10));
					y_pos_vector := std_logic_vector(to_unsigned(y_pos,10));

					--report "X: " & integer'image(to_integer(unsigned(rotating_point_x))) & "MOVED Y: " & integer'image(to_integer(unsigned(rotating_point_y)));
					
					if(x_pos = 0 or x_pos = COLUMNS-1 or y_pos = 0 or y_pos = ROWS-1) then
						pixel_on <= "1";
					elsif(x_pos_vector = rotating_point_x and y_pos_vector = rotating_point_y) then
						pixel_on <= "1";
					elsif(x_pos > 173 and x_pos < 177 and y_pos > 173 and y_pos < 177) then
						pixel_on <= "1";
					else
						pixel_on <= "0";
					end if;

					pixel_x <= x_pos_vector;
					pixel_y <= y_pos_vector;

					x_pos := x_pos + 1;

					if(x_pos = COLUMNS) then
						x_pos := 0;
						y_pos := y_pos + 1;
					end if;

				end if;
			end if;
		end if;

	end process;



end memory_writer_arq;