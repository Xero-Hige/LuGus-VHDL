library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utility.all;

entity display is

	port (
		n_0: in std_logic_vector(3 downto 0);
		n_1: in std_logic_vector(3 downto 0);
		n_2: in std_logic_vector(3 downto 0);
		mclk: in std_logic;
		hs: out std_logic;
		vs: out std_logic;
		--red_o: out std_logic_vector(2 downto 0);
		--grn_o: out std_logic_vector(2 downto 0);
		--blu_o: out std_logic_vector(1 downto 0)
		red_o: out std_logic;
		grn_o: out std_logic;
		blu_o: out std_logic
    );
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	-- attribute loc of mclk: signal is "B8";
	-- attribute loc of hs: signal is "T4";
	-- attribute loc of vs: signal is "U3";
	-- attribute loc of red_o: signal is "R8 T8 R9";
	-- attribute loc of grn_o: signal is "P6 P8 N8";
	-- attribute loc of blu_o: signal is "U4 U5";
	
	attribute loc of mclk: signal is "C9";
	 attribute loc of hs: signal is "F15";
	attribute loc of vs: signal is "F14";
	attribute loc of red_o: signal is "H14";
		attribute loc of grn_o: signal is "H15";
		attribute loc of blu_o: signal is "G15";
	
	
end;

architecture display_arq of display is

    component vga_ctrl is
		port (
			mclk: in std_logic;
			red_i: in std_logic;
			grn_i: in std_logic;
			blu_i: in std_logic;
			hs: out std_logic;
			vs: out std_logic;
			-- red_o: out std_logic_vector(2 downto 0);
			-- grn_o: out std_logic_vector(2 downto 0);
			-- blu_o: out std_logic_vector(1 downto 0);
			red_o: out std_logic;
		grn_o: out std_logic;
		blu_o: out std_logic;
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0)
		);
	end component;

	component char_ROM is
		generic(
			N: integer:= 6;
			M: integer:= 3;
			W: integer:= 8
		);
		port(
			char_address: in std_logic_vector(5 downto 0);
			font_row, font_col: in std_logic_vector(M-1 downto 0);
			rom_out: out std_logic
	);
	end component;
	
	component bcd_multiplexer is

		port(
			bcd0_input	: in std_logic_vector(3 downto 0);
			bcd1_input	: in std_logic_vector(3 downto 0);
			bcd2_input	: in std_logic_vector(3 downto 0);
			bcd3_input	: in std_logic_vector(3 downto 0);
			bcd4_input	: in std_logic_vector(3 downto 0);
			bcd5_input	: in std_logic_vector(3 downto 0);

			mux_selector    : in  std_logic_vector  (2 downto 0);
			mux_output      : out std_logic_vector  (5 downto 0)
		);
		
	end component;
	
	component rom_manager is

		generic (
			SCREEN_H:natural := 1080;
			SCREEN_W:natural := 1920;
			BITS:natural := 11
		);

		port (
			pixel_x_v: in std_logic_vector(BITS-1 downto 0);
			pixel_y_v: in std_logic_vector(BITS-1 downto 0);
			to_mux_v: out std_logic_vector(2 downto 0);
			char_x_v: out std_logic_vector(2 downto 0);
			char_y_v: out std_logic_vector(2 downto 0)
		);

	end component;

	
	signal pixel_row: std_logic_vector(9 downto 0);
	signal pixel_col: std_logic_vector(9 downto 0);
	signal color: std_logic;
	signal mux_to_rom: std_logic_vector(5 downto 0);
	signal manager_to_rom_row: std_logic_vector(2 downto 0);
	signal manager_to_rom_col: std_logic_vector(2 downto 0);
	signal manager_to_mux: std_logic_vector(2 downto 0);
	
    begin
	
		vga_controller_map: vga_ctrl
			port map(
				mclk => mclk,
				red_i => color,
				grn_i => color,
				blu_i => '1',
				hs => hs,
				vs => vs,
				red_o => red_o,
				grn_o => grn_o,
				blu_o => blu_o,
				pixel_row => pixel_row,
				pixel_col => pixel_col
			);
		char_ROM_map: char_ROM
			port map(
				char_address => mux_to_rom,
				font_row => manager_to_rom_row,
				font_col => manager_to_rom_col,
				rom_out => color
			);
			
		rom_manager_map: rom_manager
			generic map(384,680,10)
			port map(
				pixel_x_v => pixel_col,
				pixel_y_v => pixel_row,
				to_mux_v => manager_to_mux,
				char_x_v => manager_to_rom_col,
				char_y_v => manager_to_rom_row
			);
		
		bcd_multiplexer_map: bcd_multiplexer
			port map(
			
				bcd0_input => "0001",
				bcd1_input => "1010", --comma in rom
				bcd2_input => "0011",
				bcd3_input => "0100",
				bcd4_input => "1100",--V in rom
				bcd5_input => "1011", --space in rom

				mux_selector => manager_to_mux,
				mux_output => mux_to_rom
			
			
			);


    end;