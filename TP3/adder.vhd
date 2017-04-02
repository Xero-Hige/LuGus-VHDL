library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity adder is

	generic(
		BITS:natural := 16
	);

	port (
        number1_in: in  std_logic_vector(TOTAL_BITS-1 downto 0);
        number2_in: in  std_logic_vector(TOTAL_BITS-1 downto 0);
        result:     out std_logic_vector(TOTAL_BITS-1 downto 0);
        carry_out:  out std_logic
	);
end;

architecture adder_arq of adder is
begin

	process(number1_in,number2_in)
        variable s1: std_logic;
        variable s2: std_logic;
        variable s3: std_logic;
        variable carry: std_logic;
	begin
        carry := '0';
        for i in 0 to BITS-1 loop
    		s1 := number1_in(i) xor number2_in(i);
            s2 := s1 and carry;
            s3 := number1_in(i) and number2_in(i);

            result(i) <= s1 xor carry;
            carry := s2 or s3;
        end loop;
        carry_out <= carry;
	end process;

end architecture;
