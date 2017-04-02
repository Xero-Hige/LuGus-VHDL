library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_manager is

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

end;

-- architecture rom_manager_arq of rom_manager is
	-- --Se necesita calcular el rango de dibujo. Si se lo quiere centrado en la pantalla, sera un corrimiento de 4 bits a cada lado en y sobre la mitad de la pantalla y de 8*5/2 en x
	-- constant middle_x: integer := SCREEN_W/2;
	-- constant middle_y: integer := SCREEN_H/2;
	-- constant x_offset: integer := 8*5/2;
	-- constant min_x: integer := middle_x - x_offset;
	-- constant max_x: integer := middle_x + x_offset;
	-- constant min_y: integer := middle_y - 4;
	-- constant max_y: integer := middle_y + 4;
	-- begin
		-- process(pixel_x_v,pixel_y_v)
			-- variable pixel_x: integer := to_integer(unsigned(pixel_x_v));
			-- variable pixel_y: integer := to_integer(unsigned(pixel_y_v));
			-- variable local_x: integer;
			-- variable char_x: integer;
			-- variable char_y: integer;
		-- variable char: integer;
		-- begin
			-- if (pixel_x > min_x) AND (pixel_x < max_x) AND (pixel_y > min_y) AND (pixel_y < min_y) then
				-- local_x := pixel_x - min_x;
				-- char := local_x/8;
				-- char_x := local_x mod 8;
				-- char_y := pixel_y mod 8;
				-- char_x_v <= std_logic_vector(TO_UNSIGNED(char_x,3));
				-- char_y_v <= std_logic_vector(TO_UNSIGNED(char_y,3));
				-- to_mux_v <= std_logic_vector(TO_UNSIGNED(char,3));
			-- end if;
			
		-- end process;
		
		
architecture rom_manager_arq of rom_manager is
	--Se necesita calcular el rango de dibujo. Si se lo quiere centrado en la pantalla, sera un corrimiento de 4 bits a cada lado en y sobre la mitad de la pantalla y de 8*5/2 en x
	begin
		process(pixel_x_v,pixel_y_v)
			variable pixel_x: integer := 0; --to_integer(unsigned(pixel_x_v));
			variable pixel_y: integer := 0; --t-o_integer(unsigned(pixel_y_v));
			variable char_x: integer;
			variable char_y: integer;
		variable char: integer;
			begin
				pixel_x := to_integer(unsigned(pixel_x_v));
				pixel_y := to_integer(unsigned(pixel_y_v));				
				char := pixel_x/8;
				char_x := pixel_x mod 8;
				char_y := pixel_y mod 8;	
				char_x_v <= std_logic_vector(TO_UNSIGNED(char_x,3));
				char_y_v <= std_logic_vector(TO_UNSIGNED(char_y,3));
				if (pixel_x >= 320) AND (pixel_x < 360) AND (pixel_y < 192) AND (pixel_y >= 184) then
					to_mux_v <= std_logic_vector(TO_UNSIGNED(char,3));
				else
					to_mux_v <= "110";
				
				end if;
			
		end process;
end;