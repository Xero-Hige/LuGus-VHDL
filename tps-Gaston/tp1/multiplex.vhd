library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

     ENTITY bcd_mux	 IS
        PORT(
			 bcd0_i	: IN std_logic_vector(3 DOWNTO 0); 
             bcd1_i	: IN std_logic_vector(3 DOWNTO 0); 
             bcd2_i	: IN std_logic_vector(3 DOWNTO 0); 
			 bcd3_i	: IN std_logic_vector(3 DOWNTO 0); 

             m_sel	: IN std_logic_vector(1 DOWNTO 0); 
             m_out	: OUT std_logic_vector(3 DOWNTO 0));
     END bcd_mux;

     ARCHITECTURE bcd_mux_arq OF bcd_mux IS
     BEGIN

       PROCESS (bcd0_i,bcd1_i,bcd2_i,bcd3_i) IS
       BEGIN
         CASE m_sel IS
           WHEN "00" => m_out <= bcd0_i;
           WHEN "01" => m_out <= bcd1_i;
           WHEN "10" => m_out <= bcd2_i;
           WHEN "11" => m_out <= bcd3_i;
           WHEN OTHERS => m_out <= (others => '0');
         END CASE;
       END PROCESS;
     END bcd_mux_arq;