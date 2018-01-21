library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

--This component receives the real value of the tip of the vector. Then, for every bit value, it checks if it should be painted or not according to the real value.

entity memory_writer is
	generic(ROWS : integer := 350; COLUMNS : integer := 350; BITS : integer := 32);
	port(
		real_x_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
		real_y_in : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
		pixel_x_in : in std_logic_vector(9 downto 0) := (others => '0');
		pixel_y_in : in std_logic_vector(9 downto 0) := (others => '0');
		pixel_on : out std_logic_vector(0 downto 0) := (others => '0')
	);

end entity;


architecture memory_writer_arq of memory_writer is
	constant AXIS_X_BIT : std_logic_vector(9 downto 0) := std_logic_vector(shift_right(to_unsigned(COLUMNS,10),1));
	constant AXIS_Y_BIT : std_logic_vector(9 downto 0) := std_logic_vector(shift_right(to_unsigned(ROWS,10),1));
	constant ONE : unsigned(BITS - 1 downto 0) := "00000000000000010000000000000000"; --1.0
	constant PIXEL_WIDTH : unsigned(BITS - 1 downto 0) := "00000000000000000000000101110110"; --2/350
begin

	process(pixel_x_in, pixel_y_in)

		variable moved_x : unsigned(BITS - 1 downto 0) := (others => '0');
		variable moved_y : unsigned(BITS - 1 downto 0) := (others => '0');

		variable tmp_x : unsigned(BITS - 1 downto 0) := (others => '0');
		variable tmp_y : unsigned(BITS - 1 downto 0) := (others => '0');

		variable x_bit_counter : integer := 0;
		variable y_bit_counter : integer := 0;

		variable moved_x_bit : std_logic_vector(9 downto 0) := (others => '0');
		variable moved_y_bit : std_logic_vector(9 downto 0) := (others => '0');
	begin
		moved_x := unsigned(real_x_in) + ONE;
		moved_y := unsigned(real_y_in) + ONE;

		x_bit_counter := 0;
		y_bit_counter := 0;



		tmp_x := moved_x;
		tmp_y := moved_y;

		--compute bit values
		bit_vlues : for i in 0 to 350 loop
			if(tmp_x < PIXEL_WIDTH) then
				moved_x_bit := std_logic_vector(to_unsigned(x_bit_counter,10));
			end if;
			if(tmp_y < PIXEL_WIDTH) then
				moved_y_bit := std_logic_vector(to_unsigned(y_bit_counter,10));
			end if;
			x_bit_counter := x_bit_counter + 1;
			y_bit_counter := y_bit_counter + 1;
			tmp_x := tmp_x - PIXEL_WIDTH;
			tmp_y := tmp_y - PIXEL_WIDTH;
			
		end loop ; -- bit_vlues

		if(pixel_x_in = AXIS_X_BIT or pixel_y_in = AXIS_Y_BIT) then 
			pixel_on <= "1";
		elsif (pixel_x_in = moved_x_bit and pixel_y_in = moved_y_bit) then
			pixel_on <= "1";
		else
			pixel_on <= "0";
		end if;

	end process;



end memory_writer_arq;