library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component takes the result of the addition of 2 mantissas and complements it if necessary.

entity result_complementer is

	generic(
		BITS : natural := 16
	);

	port(
		in_result : in std_logic_vector(BITS - 1 downto 0) := (others => '0');
		sign_1_in : in std_logic := '0';
		sign_2_in : in std_logic := '0';
		result_cout : in std_logic := '0';
		out_result : out std_logic_vector(BITS - 1 downto 0) := (others => '0')
);
end result_complementer;

architecture result_complementer_arq of result_complementer is
	
	signal complemented_result : std_logic_vector(BITS - 1 downto 0) := (others => '0');

	component base_complementer is
		generic(
			TOTAL_BITS : natural := 16
	  );

    port(
      number_in: in  std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0');
      number_out: out std_logic_vector(TOTAL_BITS - 1 downto 0) := (others => '0')
    );
  end component;

	for base_complementer_0 : base_complementer use entity work.base_complementer;

begin

	base_complementer_0 : base_complementer
		generic map(TOTAL_BITS => BITS)
		port map (
			number_in => in_result,
			number_out => complemented_result
		);

	process(in_result, sign_1_in, sign_2_in, result_cout, complemented_result) is
		
	begin
		if((sign_1_in /= sign_2_in) and (result_cout = '0') and	(in_result(BITS - 1) = '1')) then
			out_result <= complemented_result;
		else
		 	out_result <= in_result;
		end if; 
		
	end process;

end architecture;
