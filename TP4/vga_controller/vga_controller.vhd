library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_ctrl is
  port( mclk            : in std_logic;  -- 25.175 Mhz mclk
        red_i, grn_i, blu_i : in std_logic;  -- input values for RGB signals
        pixel_row, pixel_col : out std_logic_vector(9 downto 0); -- for current pixel
        red_o, grn_o, blu_o, hs, vs : out std_logic); -- VGA drive signals
  -- The signals red_o, grn_o, blu_o, hs and vs are output to the monitor.
  -- The pixel_row and pixel_col outputs are used to know when to assert red_i,
  -- grn_i and blu_i to color the current pixel.  For VGA, the pixel_col
  -- values that are valid are from 0 to 639, all other values should
  -- be ignored.  The pixel_row values that are valid are from 0 to 479 and
  -- again, all other values are ignored.  To turn on a pixel on the
  -- VGA monitor, some combination of red_i, grn_i and blu_i should be
  -- asserted before the rising edge of the mclk.  Objects which are
  -- displayed on the monitor, assert their combination of red_i, grn_i and
  -- blu_i when they detect the pixel_row and pixel_col values are within their
  -- range.  For multiple objects sharing a screen, they must be combined
  -- using logic to create single red_i, grn_i, and blu_i signals.
end;

architecture behaviour1 of vga_ctrl is
  -- names are referenced from Altera University Program Design
  -- Laboratory Package  November 1997, ver. 1.1  User Guide Supplement
  -- mclk period = 39.72 ns; the constants are integer multiples of the
  -- mclk frequency and are close but not exact
  -- pixel_row counter will go from 0 to 524; pixel_col counter from 0 to 799
  subtype counter is std_logic_vector(9 downto 0);
  constant B : natural := 93;  -- horizontal blank: 3.77 us
  constant C : natural := 45;  -- front guard: 1.89 us
  constant D : natural := 640; -- horizontal columns: 25.17 us
  constant E : natural := 22;  -- rear guard: 0.94 us
  constant A : natural := B + C + D + E;  -- one horizontal sync cycle: 31.77 us
  constant P : natural := 2;   -- vertical blank: 64 us
  constant Q : natural := 32;  -- front guard: 1.02 ms
  constant R : natural := 480; -- vertical rows: 15.25 ms
  constant S : natural := 11;  -- rear guard: 0.35 ms
  constant O : natural := P + Q + R + S;  -- one vertical sync cycle: 16.6 ms
  
  signal vidon, hor, ver : std_logic := '0';
  signal vertical, horizontal : unsigned(9 downto 0) := (others => '0');  -- define counters
   
begin

  process
    
	 variable clk_div : std_logic := '0';
  begin
    wait until mclk = '1';
	 
	 if(clk_div = '1') then
		clk_div := '0';

  -- increment counters
      if  horizontal < A - 1  then
        horizontal <= horizontal + 1;
      else
        horizontal <= (others => '0');

        if  vertical < O - 1  then -- less than oh
          vertical <= vertical + 1;
        else
          vertical <= (others => '0');       -- is set to zero
        end if;
      end if;

  -- define hs pulse
      if  horizontal >= (D + E)  and  horizontal < (D + E + B)  then
			hor <= '1';
      else
			hor <= '0';
      end if;

  -- define vs pulse
      if  vertical >= (R + S)  and  vertical < (R + S + P)  then
			ver <= '1';
      else
			ver <= '0';
      end if;
		
		if(ver = '0' and hor = '0') then
			vidon <= '1';
		else
			vidon <= '0';
		end if;
		
		
	else
		clk_div := '1';
	end if;

  end process;
  
	vs <= ver;
	hs <= hor;
		

    -- mapping of the variable to the signals
     -- negative signs are because the conversion bits are reversed
    pixel_row <= std_logic_vector(vertical);
    pixel_col <= std_logic_vector(horizontal);
  
	red_o <= '1' when (red_i = '1' and vidon = '1') else '0';
	grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';
	blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';
		

end architecture;