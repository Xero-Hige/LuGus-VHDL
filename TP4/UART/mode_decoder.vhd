library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mode_decoder is
	generic(
		N: integer:= 6;
		M: integer:= 3;
		W: integer:= 8
	);
	port(
		clk: in std_logic := '0';
		char_in: in std_logic_vector(7 downto 0) := (others => '0');
		RxRdy: in std_logic := '0';
    mode: out std_logic_vector(1 downto 0) := (others => '0');
    angle: out std_logic_vector(31 downto 0) := (others => '0')
	);
	end mode_decoder;

architecture mode_decoder_arq of mode_decoder is

	constant LETTER_R : std_logic_vector(7 downto 0) := "01010010";
	constant LETTER_O : std_logic_vector(7 downto 0) := "01001111";
	constant LETTER_T : std_logic_vector(7 downto 0) := "01010100";
	constant LETTER_SPACE : std_logic_vector(7 downto 0) := "00100000";
	constant LETTER_C : std_logic_vector(7 downto 0) := "01000011";
	constant LETTER_A : std_logic_vector(7 downto 0) := "01000001";
	constant LETTER_H : std_logic_vector(7 downto 0) := "01001000";
	constant LETTER_0 : std_logic_vector(7 downto 0) := "00110000";
	constant LETTER_1 : std_logic_vector(7 downto 0) := "00110001";
	constant LETTER_2 : std_logic_vector(7 downto 0) := "00110010";
	constant LETTER_3 : std_logic_vector(7 downto 0) := "00110011";
	constant LETTER_4 : std_logic_vector(7 downto 0) := "00110100";
	constant LETTER_5 : std_logic_vector(7 downto 0) := "00110101";
	constant LETTER_6 : std_logic_vector(7 downto 0) := "00110110";
	constant LETTER_7 : std_logic_vector(7 downto 0) := "00110111";
	constant LETTER_8 : std_logic_vector(7 downto 0) := "00111000";
	constant LETTER_9 : std_logic_vector(7 downto 0) := "00111001";
	constant LETTER_ENTER : std_logic_vector(7 downto 0) := "00001010";

	constant SINGLE_ROTATION : std_logic_vector(1 downto 0) := "00";
	constant CONSTANT_ROTATION_RIGHT : std_logic_vector(1 downto 0) := "11";
	constant CONSTANT_ROTATION_LEFT : std_logic_vector(1 downto 0) := "01";


	signal rom_out, enable: std_logic;
	signal address: std_logic_vector(5 downto 0);
	signal font_row, font_col: std_logic_vector(M-1 downto 0);
	signal red_in, grn_in, blu_in: std_logic;
	signal pixel_row, pixel_col, pixel_col_aux, pixel_row_aux: std_logic_vector(9 downto 0);
	signal sig_startTX: std_logic;

	function CHAR_TO_NUMBER(INPUT_CHARACTER : std_logic_vector(7 downto 0) := "00000000") return integer is
	begin
		case( INPUT_CHARACTER ) is
	
			when LETTER_O => return 0;
			when LETTER_1 => return 1;
			when LETTER_2 => return 2;
			when LETTER_3 => return 3;
			when LETTER_4 => return 4;
			when LETTER_5 => return 5;
			when LETTER_6 => return 6;
			when LETTER_7 => return 7;
			when LETTER_8 => return 8;
			when LETTER_9 => return 9;
			when others => return 0;
	end case ;
 end CHAR_TO_NUMBER;
	
	begin
		
		process(RxRdy)
			variable step_to_check : integer := 0;
			variable valid : boolean := false;
			variable tmp_angle : integer := 0;
			variable angle_integer_part : std_logic_vector(15 downto 0) := (others => '0');

			variable position : integer := 0;
			type string_array is array (8 downto 0) of std_logic_vector(7 downto 0);
			variable accumm_chars : string_array := (LETTER_R,LETTER_O,LETTER_C,LETTER_SPACE,LETTER_A,LETTER_SPACE,LETTER_0,LETTER_0,LETTER_0);

		begin
			if(char_in = LETTER_ENTER) then
				mode <= "11";
			else
				mode <= "00";
			--	if(accumm_chars(0) = LETTER_R and
			--		accumm_chars(1) = LETTER_O and
			--		accumm_chars(2) = LETTER_C and
			--		accumm_chars(3) = LETTER_SPACE) then

			--		if(accumm_chars(4) = LETTER_C) then
			--			if(accumm_chars(5) = LETTER_SPACE) then
			--				if(accumm_chars(6) = LETTER_A) then
			--					mode <= CONSTANT_ROTATION_LEFT;
			--				elsif (accumm_chars(6) = LETTER_H) then
			--					mode <= CONSTANT_ROTATION_RIGHT;
			--				end if;
			--			end if;
			--		elsif(accumm_chars(4) = LETTER_A) then
			--			if(accumm_chars(5) = LETTER_SPACE) then
			--				if(position = 8) then --Means that the angle is a 3 digit one
			--					tmp_angle := CHAR_TO_NUMBER(accumm_chars(6)) * 100 + CHAR_TO_NUMBER(accumm_chars(7)) * 10 + CHAR_TO_NUMBER(accumm_chars(8));
			--				else --2 digit angle
			--					tmp_angle := CHAR_TO_NUMBER(accumm_chars(6)) * 10 + CHAR_TO_NUMBER(accumm_chars(7));
			--				end if;
			--				angle_integer_part := std_logic_vector(to_signed(tmp_angle,16));
			--				angle <= angle_integer_part & "0000000000000000";
			--				mode <= SINGLE_ROTATION;
			--			end if;
			--		end if;
			--	end if;
			--elsif(position > 8) then
			--	valid := false;
			--else
			--	accumm_chars(position) := char_in;
			--	position := position + 1;
			end if;
				
			
		end process;
	
end mode_decoder_arq;