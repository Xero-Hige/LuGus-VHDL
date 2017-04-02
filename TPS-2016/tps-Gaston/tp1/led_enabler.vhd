library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

     ENTITY led_enabler	 IS
        PORT(
			 ena_in		:	IN std_logic_vector(3 DOWNTO 0); 
             ena_out	:	OUT std_logic_vector(7 DOWNTO 0));
     END led_enabler;

     ARCHITECTURE led_enabler_arq OF led_enabler IS
     BEGIN

       PROCESS (ena_in) IS
       BEGIN
         CASE ena_in IS
           WHEN "0000" => ena_out 		<= b"11111100"; ---A->G
           WHEN "0001" => ena_out 		<= b"01100000";
           WHEN "0010" => ena_out 		<= b"11011010";
           WHEN "0011" => ena_out 		<= b"11110010";
		   WHEN "0100" => ena_out 		<= b"01100110";
           WHEN "0101" => ena_out 		<= b"10110110";
           WHEN "0110" => ena_out 		<= b"10111110";
           WHEN "0111" => ena_out		<= b"11100000";
		   WHEN "1000" => ena_out 		<= b"11111110";
           WHEN "1001" => ena_out 		<= b"11100110";
           WHEN OTHERS => ena_out 	<= b"01111100"; ---U
         END CASE;
       END PROCESS;
     END led_enabler_arq;