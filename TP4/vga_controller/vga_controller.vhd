library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga_ctrl is
  port( mclk            : in std_logic;  -- 25.175 Mhz mclk
        red_i, grn_i, blu_i : in std_logic;  -- input values for RGB signals
        pixel_row, pixel_col : out std_logic_vector(9 downto 0); -- for current pixel
        red_o, grn_o, blu_o, hs, vs : out std_logic); -- VGA drive signals
end;

architecture behaviour1 of vga_ctrl is
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

  pixel_row <= std_logic_vector(vertical);
  pixel_col <= std_logic_vector(horizontal);

	red_o <= '1' when (red_i = '1' and vidon = '1') else '0';
	grn_o <= '1' when (grn_i = '1' and vidon = '1') else '0';
	blu_o <= '1' when (blu_i = '1' and vidon = '1') else '0';
		
end architecture;
