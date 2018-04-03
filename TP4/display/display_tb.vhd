library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity display_tb is
end entity;

architecture display_tb_arq of display_tb is 

    constant MIN_X : natural := 145;  -- front guard: 1.89 us
    constant MIN_Y : natural := 65;  -- front guard: 1.02 ms

    signal clk: std_logic := '0';
    signal r,g,b: std_logic :=  '0';
    signal v : std_logic := '0';
    signal h : std_logic := '0';

    component display is
        port (
             clk: in std_logic := '0';
              rst: in std_logic := '0'; 
              ena: in std_logic := '0';

              hs: out std_logic := '0';
              vs: out std_logic := '0';
              red_o: out std_logic := '0';
              grn_o: out std_logic := '0';
              blu_o: out std_logic := '0'
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
    file file_pointer: text is out "../VGASimulator/pixels.txt";
    --file file_pointer: text open WRITE_MODE is out "write.txt";
    variable line_el: line;
    variable last_h,last_v,last_r,last_g,last_b : std_logic;
    variable x,y,last_y,h_changes,v_changes : integer := 0;
    variable enter,updated_y,logger : boolean := false;
    begin
    
    if rising_edge(clk) then
        
        if (enter = true) then
            enter := false;
            if(x >= MIN_X and x < 350 + MIN_X and y >= MIN_Y and y < 350 + MIN_Y) then
                
                        --report integer'image(x - MIN_X) & ":" & integer'image(y - MIN_Y) & " " & std_logic'image(r) & std_logic'image(g) & std_logic'image(b);

                        write(line_el, integer'image(x - MIN_X));
                        write(line_el, string'(" "));
                        write(line_el, integer'image(y - MIN_Y));
                        write(line_el, string'(" "));  
                        write(line_el, std_logic'image(r));
                        write(line_el, string'(" "));  
                        write(line_el, std_logic'image(g));
                        write(line_el, string'(" "));  
                        write(line_el, std_logic'image(b));
                        writeline(file_pointer, line_el); -- write the contents into the file.

                        last_r := r;
                        last_g := g;
                        last_b := b;
                        last_y := y;
                end if;
                x := x + 1;
                updated_y := false;
                if(x = 800) then
                    if(not updated_y) then
                        y := y + 1;
                        x := 0;
                        updated_y := true;
                    end if;
                end if;
                if(y = 525) then
                    x := 0;
                    y := 0;
                end if;


        else
            enter := true;
        end if;
    end if;
end process;
end;