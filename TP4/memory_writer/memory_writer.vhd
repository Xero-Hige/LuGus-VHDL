library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

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

	constant MAX_POSITION : integer := 176;

--	constant ROTATION_ANGLE : std_logic_vector(31 downto 0) := "00000000000000001011010000000000"; --0.703125 degrees
	constant ROTATION_ANGLE : std_logic_vector(31 downto 0) := "00000000000000000000000000000000"; --0.703125 degrees

	signal clk_signal : std_logic := '0';

	signal x_input_to_memory : std_logic_vector(15 downto 0) := (others => '0');
	signal y_input_to_memory : std_logic_vector(15 downto 0) := (others => '0');
	signal x_input_address_to_memory : std_logic_vector(9 downto 0) := (others => '0');
	signal y_input_address_to_memory : std_logic_vector(9 downto 0) := (others => '0');


	signal x_output_from_memory : std_logic_vector(15 downto 0) := (others => '0');
	signal y_output_from_memory : std_logic_vector(15 downto 0) := (others => '0');
	signal x_output_address_from_memory : std_logic_vector(9 downto 0) := (others => '0');
	signal y_output_address_from_memory : std_logic_vector(9 downto 0) := (others => '0');

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

	clk_signal <= clk;

	cordic_0 : cordic
    port map(
      x_in => unrotated_x,
      y_in => unrotated_y,
      angle => rotation_angle_signal,
      x_out => cordic_to_writer_x,
      y_out => cordic_to_writer_y
    );

   x_values_ram: RAMB16_S18_S18
    generic map(WRITE_MODE_B => "READ_FIRST",
			INIT_00 => X"017602EC046305D9075008C60A3D0BB30D2A0EA01017118D1304147A15F11767",
			INIT_01 => X"18DE1A541BCB1D411EB8202E21A5231B24922608277F28F52A6C2BE22D592ECF",
			INIT_02 => X"304631BC333334A936203796390D3A833BFA3D703EE7405D41D4434A44C14637",
			INIT_03 => X"47AE49244A9B4C114D884EFE507551EB536254D8564E57C5593B5AB25C285D9F",
			INIT_04 => X"5F15608C6202637964EF666667DC69536AC96C406DB66F2D70A3721A73907507",
			INIT_05 => X"767D77F4796A7AE17C577DCE7F4480BB823183A8851E8695880B89828AF88C6F",
			INIT_06 => X"8DE58F5C90D2924993BF953696AC982399999B109C869DFD9F73A0EAA260A3D7",
			INIT_07 => X"A54DA6C4A83AA9B1AB27AC9DAE14AF8AB101B277B3EEB564B6DBB851B9C8BB3E",
			INIT_08 => X"BCB5BE2BBFA2C118C28FC405C57CC6F2C869C9DFCB56CCCCCE43CFB9D130D2A6",
			INIT_09 => X"D41DD593D70AD880D9F7DB6DDCE4DE5ADFD1E147E2BEE434E5ABE721E898EA0E",
			INIT_0a => X"EB85ECFBEE72EFE8F15FF2D5F44CF5C2F739F8AFFA26FB9CFD13FE89FFFF0000"
    )
    port map (
      DOA  => open,
      DOB  => x_output_from_memory,
      ADDRA => x_input_address_to_memory,
      ADDRB => x_output_address_from_memory,
      DIPA => (others => '0'),
      DIPB => (others => '0'),
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => x_input_to_memory,
      DIB  => (others => '0'),
      ENA  => enable,
      ENB  => enable,
      SSRA  => '0',
      SSRB => '0',
      WEA  => enable,
      WEB  => '0'
    );

   y_values_ram: RAMB16_S18_S18
    generic map(WRITE_MODE_B => "READ_FIRST")
    port map (
      DOA  => open,
      DOB  => y_output_from_memory,
      ADDRA => y_input_address_to_memory,
      ADDRB => y_output_address_from_memory,
      DIPA => (others => '0'),
      DIPB => (others => '0'),
      CLKA  => clk_signal,
      CLKB => clk_signal,
      DIA  => y_input_to_memory,
      DIB  => (others => '0'),
      ENA  => enable,
      ENB  => enable,
      SSRA  => '0',
      SSRB => '0',
      WEA  => '0',
      WEB  => '0'
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

	begin

		if(rst = '1') then --reset values
			point_position := 0;
			pixel_on <= (others => '0');
		elsif(rising_edge(clk)) then

			if(enable = '1') then

				if(point_position < MAX_POSITION) then

					--To give time to the cordic to process the data, we shall draw the previous point and in the end set the next point to be processed
					moved_x := unsigned("0000000000000000" & x_output_from_memory) + ONE; --Move the x value to the right so that all it's posible locations are a positive number
					moved_y := unsigned("0000000000000000" & y_output_from_memory) + ONE; --Move the y value up so that all it's possible locations are a positive number

					extended_moved_x_bit := std_logic_vector(moved_x * PIXEL_COEF); --Compute the pixel location
					moved_x_bit := extended_moved_x_bit(32 + 9 downto 32); --Truncate to integer value
					
					extended_moved_y_bit_unsigned := moved_y * PIXEL_COEF; --Compute the pixel location
					truncated_extended_moved_y_bit_unsigned := extended_moved_y_bit_unsigned(32 + 9 downto 32); --Truncate to integer value
					inverted_y_bit := ROWS - truncated_extended_moved_y_bit_unsigned;
					moved_y_bit := std_logic_vector(inverted_y_bit);

					--report "POS: " & integer'image(point_position);
					--report "X:" & integer'image(to_integer(unsigned(moved_x_bit)));
					--report "Y:" & integer'image(to_integer(unsigned(moved_y_bit)));

					pixel_x <= moved_x_bit;
					pixel_y <= moved_y_bit;
					pixel_on <= "1";

					unrotated_x <= "0000000000000000" & x_output_from_memory;
					unrotated_y <= "0000000000000000" & y_output_from_memory;

					--Save the last rotated point and set current to be rotated
					if(point_position > 0) then
						x_input_to_memory <= cordic_to_writer_x(15 downto 0);
						y_input_to_memory <= cordic_to_writer_y(15 downto 0);

						x_input_address_to_memory <= std_logic_vector(to_unsigned(point_position - 1,10));
						y_input_address_to_memory <= std_logic_vector(to_unsigned(point_position - 1,10));

						x_output_address_from_memory <= std_logic_vector(to_unsigned(point_position,10));
						y_output_address_from_memory <= std_logic_vector(to_unsigned(point_position,10));

					end if;
					
					point_position := point_position + 1;

				else
					pixel_on <= "0";
				end if;



			end if;

		end if;

	end process;



end memory_writer_arq;