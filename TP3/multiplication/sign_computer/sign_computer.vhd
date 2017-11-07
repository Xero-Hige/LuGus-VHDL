library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_computer is
  port(
    sign1_in : in std_logic;
    sign2_in : in std_logic;
    sign_out : out std_logic
  );
end;


architecture sign_computer_arq of sign_computer is
begin
    process(sign1_in, sign2_in)
    begin
      sign_out <= sign1_in xor sign2_in;
    end process;
end architecture;
