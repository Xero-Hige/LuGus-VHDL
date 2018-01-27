library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--This component will map an address sent to the memory so that

entity memory_read_proxy is
    generic(STARTING_X: integer := 0; STARTING_Y: integer := 0; X_LENGTH: integer := 350; Y_LENGTH: integer := 350);
    port(
      x_in: in std_logic_vector(9 downto 0) := (others => '0');
      y_in: in std_logic_vector(9 downto 0) := (others => '0');
      memory_value: in std_logic_vector(0 downto 0) := (others => '0');
      x_out: out std_logic_vector(9 downto 0) := (others => '0');
      y_out: out std_logic_vector(9 downto 0) := (others => '0');
      proxy_value: out std_logic_vector(0 downto 0) := (others => '0')
    );

end memory_read_proxy;

architecture memory_read_proxy_arq of memory_read_proxy is

	signal memory_data : std_logic_vector(0 downto 0) := (others => '0');

begin
	process(x_in,y_in,memory_value,memory_data)
		variable x_in_int : integer := 0;
		variable y_in_int : integer := 0;
	begin
		x_in_int := to_integer(unsigned(x_in));
		y_in_int := to_integer(unsigned(y_in));
		memory_data <= memory_value;
		
		if(x_in_int >= STARTING_X and 
				x_in_int <= (STARTING_X + X_LENGTH) and
				 y_in_int >= STARTING_Y and
				  y_in_int <= (STARTING_Y + Y_LENGTH)) then
			x_out <= std_logic_vector(to_unsigned(x_in_int - STARTING_X,10));
			y_out <= std_logic_vector(to_unsigned(y_in_int - STARTING_Y,10));
			proxy_value <= memory_data;
		else
			x_out <= (others => '0');
			y_out <= (others => '0');
			proxy_value <= (others => '0');
		end if;
	end process;
end architecture;