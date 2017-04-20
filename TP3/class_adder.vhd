library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit_unsigned.all;

entity class_adder is
     generic(N: integer:= 4);
     port(
          number1_in: in std_logic_vector(N-1 downto 0);
          number2_in: in std_logic_vector(N-1 downto 0);
          cin:        in std_logic;

          result:     out std_logic_vector(N-1 downto 0);
          cout:       out std_logic
     );
end;

architecture class_adder_arq of class_adder is
     signal aux: std_logic_vector(N+1 downto 0);

     begin
         aux    <= ('0' & number1_in & cin) + ('0' & number2_in & '1');
         result <= aux (N downto 1);
         cout   <= aux (N+1);
end;
