Library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.numeric_std.all;


entity cordic_commander is
  generic(TOTAL_BITS : integer := 32);
  port(
    clk : in std_logic := '0';
    enable : in std_logic := '0';
	 rx
  );
end cordic_commander;

architecture cordic_commander_arq of cordic_commander is

  constant CONSTANT_ROTATION_ANGLE_LEFT : std_logic_vector(31 downto 0) := "00000000000000001011010000000000"; --0.703125 degrees
  constant CONSTANT_ROTATION_ANGLE_RIGHT : std_logic_vector(31 downto 0) := "11111111111111110100110000000000"; --(-0.703125) degrees
   
begin

  process(clk)
    variable tmp_angle : std_logic_vector(TOTAL_BITS - 1  downto 0) := (others => '0');
    variable rotating_mode : integer := 0; -- -1: constant rotation left, 0 rotate angle, 1: constant rotation right
    variable rotated : boolean := false;
    variable mode_int : integer := 0;
  begin

    mode_int := to_integer(signed(mode));

    if(rising_edge(clk)) then

      case( mode_int ) is
      
        when 0 =>
          if(not  rotated) then
            angle <= tmp_angle;
            rotated := true;
          else 
            angle <= (others => '0');
          end if;
        when 1 => 
          angle <= CONSTANT_ROTATION_ANGLE_LEFT;
          rotated := false;
        when -1 => 
          angle <= CONSTANT_ROTATION_ANGLE_RIGHT; 
          rotated := false;
        when others =>
          angle <= (others => '0');
          rotated := false;
     end case ;
    end if;
      

  end process;

end architecture;