library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

     ENTITY anode_sel	 IS
        PORT(
			 sel_in	: IN std_logic_vector(1 DOWNTO 0); 
             sel_out	: OUT std_logic_vector(3 DOWNTO 0));
     END anode_sel;

     ARCHITECTURE anode_sel_arq OF anode_sel IS
     BEGIN
		
       PROCESS (sel_in) IS
       BEGIN
         CASE sel_in IS
           WHEN "00" => sel_out <= b"0001";
           WHEN "01" => sel_out <= b"0010";
           WHEN "10" => sel_out <= b"0100";
           WHEN "11" => sel_out <= b"1000";
           WHEN OTHERS => sel_out <= (others => '0');
         END CASE;
       END PROCESS;
     END anode_sel_arq;