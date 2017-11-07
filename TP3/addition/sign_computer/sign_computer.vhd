library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_computer is

    generic(
		BITS : natural := 16
	  );

    port(
      man_1_in: in  std_logic_vector(BITS - 1 downto 0) := (others => '0');
      man_2_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      sign_1_in: in std_logic := '0';
      sign_2_in: in std_logic := '0';
      man_greater_in: in std_logic_vector(BITS - 1 downto 0) := (others => '0');
      pre_complemented_result: in std_logic_vector(BITS*2 - 1 downto 0) := (others => '0');
      complemented_result: in std_logic_vector(BITS*2 - 1 downto 0) := (others => '0');
      sign_out: out std_logic := '0'
    );

end sign_computer;

architecture sign_computer_arq of sign_computer is
    begin
    	process (man_1_in, man_2_in, sign_1_in, sign_2_in, man_greater_in, pre_complemented_result, complemented_result) is
    		begin
    			if sign_1_in = sign_2_in then
                    sign_out <= sign_1_in; --If the operands had the same sign, return it
                elsif man_1_in /= man_greater_in then --There was an operand switch
                    sign_out <= sign_2_in;
                else 
                    if(pre_complemented_result = complemented_result) then --Result was not complemented
                        sign_out <= sign_1_in;
                    else --result was complemented
                        sign_out <= sign_2_in;
                    end if;
            end if;
        end process;
end architecture;