library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity display_tb is
end entity;

architecture display_tb_arq of display_tb is

    signal clk: std_logic := '0';
    signal r: std_logic_vector(2 downto 0) := (others => '0');
    signal g: std_logic_vector(2 downto 0) := (others => '0');
    signal b : std_logic_vector(1 downto 0) := (others => '0');
    signal v : std_logic := '0';
    signal h : std_logic := '0';

    component display is
        port (
             clk: in std_logic := '0';
              rst: in std_logic := '0'; 
              ena: in std_logic := '0';

              hs: out std_logic := '0';
              vs: out std_logic := '0';
              red_o: out std_logic_vector(2 downto 0) := (others => '0');
              grn_o: out std_logic_vector(2 downto 0) := (others => '0');
              blu_o: out std_logic_vector(1 downto 0) := (others => '0')
        );
    end component;

    begin

    display_0 : display
        port map(
            clk => clk,
            rst => '0',
            ena => '1',
            hs => h,
            vs => v,
            red_o => r,
            grn_o => g,
            blu_o => b
        );

    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    process (clk)
    file file_pointer: text is out "write.txt";
    variable line_el: line;
    variable logger : boolean := false;
        begin

    if rising_edge(clk) then

        --if(logger =  false) then
        --    logger := true;

        --else

            -- Write the time
            write(line_el, now); -- write the line.
            write(line_el, string'(":")); -- write the line.

            -- Write the hsync
            write(line_el, string'(" "));
            write(line_el, h); -- write the line.

            -- Write the vsync
            write(line_el, string'(" "));
            write(line_el, v); -- write the line.

            -- Write the red
            write(line_el, string'(" "));
            write(line_el, r); -- write the line.

            -- Write the green
            write(line_el, string'(" "));
            write(line_el, g); -- write the line.

            -- Write the blue
            write(line_el, string'(" "));
            write(line_el, b); -- write the line.

            writeline(file_pointer, line_el); -- write the contents into the file.

            logger := false;

        --end if;

    end if;
end process;
end;