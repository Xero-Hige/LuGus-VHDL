library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utility.all;
Library UNISIM;
use UNISIM.vcomponents.all;

entity display is

	port (
		mclk: in std_logic;
		mrst: in std_logic;	
		mena: in std_logic;
		
		v_in_plus: in std_logic;
		v_in_minus: in std_logic;
		v_out: out std_logic;

		hs: out std_logic;
		vs: out std_logic;
		red_o: out std_logic_vector(2 downto 0);
		grn_o: out std_logic_vector(2 downto 0);
		blu_o: out std_logic_vector(1 downto 0)
		-- red_o: out std_logic;
		-- grn_o: out std_logic;
		-- blu_o: out std_logic
    );
	
	attribute loc: string;
			
	-- Mapeo de pines para el kit Nexys 2 (spartan 3E)
	attribute loc of mclk: signal is "B8";
	attribute loc of hs: signal is "T4";
	attribute loc of vs: signal is "U3";
	attribute loc of red_o: signal is "R8 T8 R9";
	attribute loc of grn_o: signal is "P6 P8 N8";
	attribute loc of blu_o: signal is "U4 U5";
	attribute loc of mrst: signal is "H13";
	attribute loc of mena: signal is "E18";
	attribute loc of v_in_plus: signal is "G15";
	attribute loc of v_in_minus: signal is "G16";
	attribute loc of v_out: signal is "H16";
	
	--attribute loc of mclk: signal is "C9";
	--attribute loc of mrst: signal is "H13";
	--attribute loc of mena: signal is "D18";

	--attribute loc of hs: signal is "F15";
	--attribute loc of vs: signal is "F14";
	--attribute loc of red_o: signal is "H14";
	--attribute loc of grn_o: signal is "H15";
	--attribute loc of blu_o: signal is "G15";
	
	
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
			red_o: out std_logic_vector(2 downto 0);
			grn_o: out std_logic_vector(2 downto 0);
			blu_o: out std_logic_vector(1 downto 0);
			-- red_o: out std_logic;
			-- grn_o: out std_logic;
			-- blu_o: out std_logic;
			pixel_row: out std_logic_vector(9 downto 0);
			pixel_col: out std_logic_vector(9 downto 0)
		);
	end component;
	
	component ones_generator is
	generic (
		PERIOD: natural := 30000;
		COUNT: natural := 15500
	);
	
	port(
		clk: in std_logic;
		count_o: out std_logic
		);
end component;

	component bcd_1_counter is

		generic (
			COUNTERS:natural := 5;
			OUTPUT:natural := 3
		);

		port (
			clk_in: in std_logic;
			rst_in: in std_logic;
			ena_in: in std_logic;
			counter_out: out bcd_vector (OUTPUT-1 downto 0)
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
	
	component FFD_Array is
		generic (
			SIZE: natural := 12
		);
		
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			Q: out std_logic_vector(SIZE-1 downto 0);
			D: in std_logic_vector(SIZE-1 downto 0)
			);
	end component;
	
	component voltage_registry_enabler is

		port (
			clk_in: in std_logic;
			rst_in: in std_logic;
			ena_in: in std_logic;
			out_1: out std_logic;
			out_2: out std_logic
		);
	
	end component;

	
	signal pixel_row: std_logic_vector(9 downto 0);
	signal pixel_col: std_logic_vector(9 downto 0);
	signal color: std_logic;
	signal mux_to_rom: std_logic_vector(5 downto 0);
	signal manager_to_rom_row: std_logic_vector(2 downto 0);
	signal manager_to_rom_col: std_logic_vector(2 downto 0);
	signal manager_to_mux: std_logic_vector(2 downto 0);
	
	signal reg_to_mux1: std_logic_vector(3 downto 0);
	signal reg_to_mux2: std_logic_vector(3 downto 0);
	signal reg_to_mux3: std_logic_vector(3 downto 0);
	
	signal ones_generator_to_counter: std_logic;
		
	signal enabler_to_reg: std_logic;
	signal enabler_to_counter: std_logic;
	
	signal reg_in0: std_logic_vector(3 downto 0);
	signal reg_in1: std_logic_vector(3 downto 0);
	signal reg_in2: std_logic_vector(3 downto 0);
	signal reg_in: std_logic_vector(11 downto 0);
	
	signal v_out_aux: std_logic; 
	
	signal  to_ff:std_logic;

    begin
		reg_in <= reg_in0&reg_in1&reg_in2;
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
		
		FFD_Array_map: FFD_Array
			generic map(12) 
			port map(
			enable => enabler_to_reg,
			reset => mrst,
			clk => mclk,
			Q(3 downto 0) => reg_to_mux1,
			Q(7 downto 4) => reg_to_mux2,
			Q(11 downto 8) => reg_to_mux3,
			D => reg_in
			);

		
		bcd_multiplexer_map: bcd_multiplexer
			port map(
			
				bcd0_input => reg_to_mux1,
				bcd1_input => "1010", --comma in rom
				bcd2_input => reg_to_mux2,
				bcd3_input => reg_to_mux3,
				bcd4_input => "1100",--V in rom
				bcd5_input => "1011", --space in rom

				mux_selector => manager_to_mux,
				mux_output => mux_to_rom
			
			
			);
		
		ones_generator_map: ones_generator
			generic map(33000,23100)
			port map(
				clk => mclk,
				count_o => ones_generator_to_counter
			);
			
		v_out <= v_out_aux;	
		bcd_1_counter_map: bcd_1_counter
			port map(
				clk_in => mclk,
				rst_in => enabler_to_counter,
				ena_in => v_out_aux,
				counter_out(0) => reg_in0,
				counter_out(1) => reg_in1,
				counter_out(2) => reg_in2
			);
	
		voltage_registry_enabler_map: voltage_registry_enabler

			port map(
				clk_in => mclk,
				rst_in => mrst,
				ena_in => '1',
				out_1 => enabler_to_reg,
				out_2 => enabler_to_counter
			);
			
		
	   IBUFDS_inst : IBUFDS
	   -- generic map (
		  -- CAPACITANCE => "DONT_CARE", -- "LOW", "NORMAL", "DONT_CARE" (Spartan-3 only)
		  -- DIFF_TERM => FALSE, -- Differential Termination 
		  -- IOSTANDARD => "DEFAULT")
	   port map (
		  O => to_ff,  -- Buffer output
		  I => v_in_plus,  -- Diff_p buffer input (connect directly to top-level port)
		  IB => v_in_minus 	 -- Diff_n buffer input (connect directly to top-level port)
	   );
	   
	   FFD_Array_map2: FFD_Array
			generic map(1) 
			port map(
				enable => '1',
				reset => mrst,
				clk => mclk,
				Q(0) => v_out_aux,
				D(0) => to_ff
			);

    end;