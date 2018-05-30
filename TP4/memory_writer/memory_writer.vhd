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

	constant MAX_POSITION : integer := 177;

	constant ROTATION_ANGLE : signed(31 downto 0) := "00000000000000001011010000000000"; --0.703125 degrees
	--constant ROTATION_ANGLE : signed(31 downto 0) := "00000000000000000000000000000000";

	signal clk_signal : std_logic := '0';

	--Signals to memory
	signal x_read_address_to_memory : std_logic_vector(9 downto 0) := (others => '0');

	--Signals from memory
	signal memory_read_x : std_logic_vector(15 downto 0) := (others => '0');

	--Signals to preprocessor
	signal preprocessor_x_input : std_logic_vector(BITS-1  downto 0) := (others => '0');
	signal preprocessor_y_input : std_logic_vector(BITS-1  downto 0) := (others => '0');
	signal preprocessor_angle_input : std_logic_vector(BITS-1  downto 0) := (others => '0');

	--Signals to cordic
	signal preprocessor_x_output_to_cordic : std_logic_vector(BITS - 1 downto 0) := (others => '0');
	signal preprocessor_y_output_to_cordic : std_logic_vector(BITS - 1 downto 0) := (others => '0');
	signal preprocessor_angle_output_to_cordic : std_logic_vector(BITS - 1 downto 0) := (others => '0');

	--Output signals
	signal output_x_from_cordic : std_logic_vector(BITS - 1 downto 0 ) := (others => '0');
	signal output_y_from_cordic : std_logic_vector(BITS - 1 downto 0 ) := (others => '0');

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

  component preprocessor is
		generic(TOTAL_BITS: integer := 32);
    port(
      x_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_in: in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_in : in std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      x_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      y_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      angle_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
	end component;

begin

	clk_signal <= clk;

	preprocessor_0 : preprocessor
		port map(
			x_in => preprocessor_x_input,
			y_in => preprocessor_y_input,
			angle_in => preprocessor_angle_input,
			x_out => preprocessor_x_output_to_cordic,
			y_out => preprocessor_y_output_to_cordic,
			angle_out => preprocessor_angle_output_to_cordic
		);

	cordic_0 : cordic
    port map(
      x_in => preprocessor_x_output_to_cordic,
      y_in => preprocessor_y_output_to_cordic,
      angle => preprocessor_angle_output_to_cordic,
      x_out => output_x_from_cordic,
      y_out => output_y_from_cordic
    );

   x_values_ram: RAMB16_S18_S18
    generic map(WRITE_MODE_B => "READ_FIRST",
			INIT_00 => X"176715F1147A1304118D10170EA00D2A0BB30A3D08C6075005D9046302EC0176",
			INIT_01 => X"2ECF2D592BE22A6C28F5277F26082492231B21A5202E1EB81D411BCB1A5418DE",
			INIT_02 => X"463744C1434A41D4405D3EE73D703BFA3A83390D3796362034A9333331BC3046",
			INIT_03 => X"5D9F5C285AB2593B57C5564E54D8536251EB50754EFE4D884C114A9B492447AE",
			INIT_04 => X"75077390721A70A36F2D6DB66C406AC9695367DC666664EF63796202608C5F15",
			INIT_05 => X"8C6F8AF88982880B8695851E83A8823180BB7F447DCE7C577AE1796A77F4767D",
			INIT_06 => X"A3D7A260A0EA9F739DFD9C869B109999982396AC953693BF924990D28F5C8DE5",
			INIT_07 => X"BB3EB9C8B851B6DBB564B3EEB277B101AF8AAE14AC9DAB27A9B1A83AA6C4A54D",
			INIT_08 => X"D2A6D130CFB9CE43CCCCCB56C9DFC869C6F2C57CC405C28FC118BFA2BE2BBCB5",
			INIT_09 => X"EA0EE898E721E5ABE434E2BEE147DFD1DE5ADCE4DB6DD9F7D880D70AD593D41D",
			INIT_0a => X"FFFFFFFFFE89FD13FB9CFA26F8AFF739F5C2F44CF2D5F15FEFE8EE72ECFBEB85"
    )
    port map (
      DOA  => open,
      DOB  => memory_read_x,
      ADDRA => (others => '0'),
      ADDRB => x_read_address_to_memory,
      DIPA => (others => '0'),
      DIPB => (others => '0'),
      CLKA  => '0',
      CLKB => clk_signal,
      DIA  => (others => '0'),
      DIB  => (others => '0'),
      ENA  => '0',
      ENB  => enable,
      SSRA  => '0',
      SSRB => '0',
      WEA  => '0',
      WEB  => '0'
    );


   --y_values_ram: RAMB16_S18_S18
   -- generic map(WRITE_MODE_B => "READ_FIRST")
   -- port map (
   --   DOA  => open,
   --   DOB  => memory_read_y,
   --   ADDRA => open,
   --   ADDRB => y_read_address_to_memory,
   --   DIPA => (others => '0'),
   --   DIPB => (others => '0'),
   --   CLKA  => clk_signal,
   --   CLKB => clk_signal,
   --   DIA  => y_input_to_memory,
   --   DIB  => (others => '0'),
   --   ENA  => enable,
   --   ENB  => enable,
   --   SSRA  => '0',
   --   SSRB => '0',
   --   WEA  => enable,
   --   WEB  => '0'
   -- );

  preprocessor_x_input <= ("0000000000000000" & memory_read_x);
  preprocessor_y_input <= (others => '0');
  
	process(clk, rst)

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
		
		variable erasing_x : integer := 0;
		variable erasing_y : integer := 0;

		variable should_erase : std_logic := '0';
		variable done_writing : std_logic := '0';

		variable accumulated_angle : signed(BITS - 1 downto 0) := (others => '0');
		variable local_accumulated_angle : signed(BITS - 1 downto 0) := (others => '0');
		variable accumulated_angle_int : integer := 0;
		variable accumulated_angle_fractional : signed((BITS/2) - 1 downto 0) := (others => '0');

	begin

		if(rising_edge(clk)) then
			--If rst is 1 we should either erase previous values or start writing the new ones
			if(rst = '1') then
				if(should_erase = '1') then
					erasing_x := erasing_x + 1;
					if(erasing_x = COLUMNS) then
						erasing_x := 0;
						erasing_y := erasing_y + 1;
					end if;
					if(erasing_y = ROWS) then
						should_erase := '0';
					end if;
					report "ERASING: " & integer'image(erasing_x) & ":" & integer'image(erasing_y);
					pixel_x <= std_logic_vector(to_unsigned(erasing_x, 10));
					pixel_y <= std_logic_vector(to_unsigned(erasing_y, 10));
					pixel_on <= (others => '0');
					point_position := 0;
					x_read_address_to_memory <= std_logic_vector(to_unsigned(point_position,10));
				else --We should start writing the next values
					if(point_position >= 0  and point_position < MAX_POSITION) then
						point_position := point_position + 1;
						
						--Compute address to set to memory
						x_read_address_to_memory <= std_logic_vector(to_unsigned(point_position,10));

						--To give time to the cordic to process the data, we shall draw the previous point and in the end set the next point to be processed
						moved_x := unsigned(output_x_from_cordic) + ONE; --Move the x value to the right so that all it's posible locations are a positive number
						moved_y := unsigned(output_y_from_cordic) + ONE; --Move the y value up so that all it's possible locations are a positive number

						extended_moved_x_bit := std_logic_vector(moved_x * PIXEL_COEF); --Compute the pixel location
						moved_x_bit := extended_moved_x_bit(32 + 9 downto 32); --Truncate to integer value
						
						extended_moved_y_bit_unsigned := moved_y * PIXEL_COEF; --Compute the pixel location
						truncated_extended_moved_y_bit_unsigned := extended_moved_y_bit_unsigned(32 + 9 downto 32); --Truncate to integer value
						inverted_y_bit := ROWS - truncated_extended_moved_y_bit_unsigned;
						moved_y_bit := std_logic_vector(inverted_y_bit);

						report "WRITTING: " & integer'image(point_position);

						pixel_x <= moved_x_bit;
						pixel_y <= moved_y_bit;
						pixel_on <= "1";
					else
						report "DONE WRITTING -> WAITING_TO_ERASE";
						pixel_on <= "0";
						erasing_x := 0;
						erasing_y := 0;
					end if;
				end if;
			else
				report "VIDEO ON, DONT MODIFY MEMORY";
				if(should_erase = '0') then
					local_accumulated_angle := accumulated_angle + ROTATION_ANGLE;
					accumulated_angle_int := to_integer(local_accumulated_angle(BITS - 1 downto BITS/2));
					accumulated_angle_fractional := local_accumulated_angle((BITS/2) - 1 downto 0);
					if(accumulated_angle_int >= 360) then
						accumulated_angle_int := accumulated_angle_int - 360;
					end if;
					accumulated_angle := to_signed(accumulated_angle_int,BITS/2) & accumulated_angle_fractional;
					preprocessor_angle_input <= std_logic_vector(accumulated_angle);
				end if;

				should_erase := '1';
				erasing_x := 0;
				erasing_y := 0;
				
			end if;
		end if;
	end process;



end memory_writer_arq;