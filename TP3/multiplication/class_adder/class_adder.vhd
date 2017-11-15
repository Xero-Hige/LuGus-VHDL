library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
    signal aux: signed (N+1 downto 0) := to_signed(0, N+2);

    begin
      aux    <= ('0' & signed(number1_in) & cin) + ('0' & signed(number2_in) & '1');
      result <= std_logic_vector( aux (N downto 1) );
      cout   <= aux (N+1);
end;
