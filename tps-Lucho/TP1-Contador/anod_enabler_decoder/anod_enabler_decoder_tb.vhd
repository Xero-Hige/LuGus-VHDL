library ieee;
use ieee.std_logic_1164.all;

entity anod_enabler_decoder_tb is
end;

architecture anod_enabler_decoder_tb_func of anod_enabler_decoder_tb is
	signal data_in: std_logic_vector(1 downto 0) := (others => '0');
	signal data_out: std_logic_vector(3 downto 0) := (others => '0');

	
	
	component anod_enabler_decoder is
		port(
			binary_in: in std_logic_vector(1 downto 0); --"2 bit vector to switch between the 4 possible anod values"
			code_out: out std_logic_vector(3 downto 0) --4 bit output to switch between anod
		);
	end component;

	
begin

	data_in(0) <= not(data_in(0)) after 20 ns;
	data_in(1) <= not(data_in(1)) after 40 ns;
	
	
	anodEnablerMap: anod_enabler_decoder
		port map(
			binary_in => data_in,
			code_out => data_out
		);
		
end architecture;		
