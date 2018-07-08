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
		angle: out std_logic_vector(31 downto 0) := (others => '0');
		led0 : out std_logic := '0';
		led1 : out std_logic := '0';
		led2 : out std_logic := '0';
		led3 : out std_logic := '0';
		led4 : out std_logic := '0';
		led5 : out std_logic := '0';
		led6 : out std_logic := '0';
		led7 : out std_logic := '0'
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
			when LETTER_0 => return 0;
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

	function IS_NUMBER(INPUT_CHARACTER : std_logic_vector(7 downto 0) := "00000000") return boolean is
	begin
		case( INPUT_CHARACTER ) is
			when LETTER_0 => return true;
			when LETTER_1 => return true;
			when LETTER_2 => return true;
			when LETTER_3 => return true;
			when LETTER_4 => return true;
			when LETTER_5 => return true;
			when LETTER_6 => return true;
			when LETTER_7 => return true;
			when LETTER_8 => return true;
			when LETTER_9 => return true;
			when others => return false;
	end case ;
	end IS_NUMBER;

	function ROUND(ANGLE : integer := 0) return integer is
	begin
		if(ANGLE >= 360) then
			return angle - 360;
		else
			return angle;
		end if;
	end ROUND;

	begin
		process(clk)
			variable tmp_angle : integer := 0;
			variable position : integer := 0;
		begin
			if(rising_edge(clk)) then
				if(RxRdy = '1') then
					if(not IS_NUMBER(char_in) and position > 6) then
						position := 0;
					end if;
					if(position = 0 and char_in = LETTER_R) then
						position := position + 1;
					elsif(position = 1 and char_in = LETTER_O) then
						position := position + 1;
						mode <= CONSTANT_ROTATION_RIGHT;
					elsif(position = 2 and char_in = LETTER_T) then
						position := position + 1;
					elsif(position = 3 and char_in = LETTER_SPACE) then
						position := position + 1;
					elsif(position = 4 and (char_in = LETTER_C or char_in = LETTER_A)) then
						position := position + 1;
					elsif(position = 5 and char_in = LETTER_SPACE) then
						position := position + 1;
					elsif(position = 6) then
						if(char_in = LETTER_H) then
							mode <= CONSTANT_ROTATION_RIGHT;
							position := 0;
						elsif(char_in = LETTER_A) then
							mode <= CONSTANT_ROTATION_LEFT;
							position := 0;
						elsif(IS_NUMBER(char_in) = true) then
							tmp_angle := CHAR_TO_NUMBER(char_in);
							angle <= std_logic_vector(to_signed(tmp_angle, 16)) & "0000000000000000";
							mode <= SINGLE_ROTATION;
							position := position + 1;
						else
							position := 0;
						end if;
					elsif(position = 7 and IS_NUMBER(char_in)) then
						tmp_angle := tmp_angle * 10 + CHAR_TO_NUMBER(char_in);
						angle <= std_logic_vector(to_signed(tmp_angle, 16)) & "0000000000000000";
						mode <= SINGLE_ROTATION;
						position := position + 1;
					elsif(position = 8 and IS_NUMBER(char_in)) then
						tmp_angle := ROUND(tmp_angle * 10 + CHAR_TO_NUMBER(char_in));
						mode <= SINGLE_ROTATION;
						angle <= std_logic_vector(to_signed(tmp_angle, 16)) & "0000000000000000";
						position := 0;
					else
						position := 0;
					end if;
				end if;
			end if;
		end process;

end;
