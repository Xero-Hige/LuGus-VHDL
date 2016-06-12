library ieee;
use ieee.std_logic_1164.all;

entity four_port_multiplexer_tb is
end;

architecture four_port_multiplexer_tb_func of four_port_multiplexer_tb is
	signal data_in_a: std_logic_vector(3 downto 0) := (others => '0');
	signal data_in_b: std_logic_vector(3 downto 0) := (others => '1');
	signal data_in_c: std_logic_vector(3 downto 0) := "0101";
	signal data_in_d: std_logic_vector(3 downto 0) := "1010";
	signal data_out: std_logic_vector(3 downto 0) := (others => '0');
	signal select_in: std_logic_vector(1 downto 0) := (others  => '0');
	
	
	component four_port_multiplexer is
		generic(
			BITS:natural := 1);
		port (
			data_in_a: in std_logic_vector(BITS-1 downto 0); 	
			data_in_b: in std_logic_vector(BITS-1 downto 0);
			data_in_c: in std_logic_vector(BITS-1 downto 0);
			data_in_d: in std_logic_vector(BITS-1 downto 0);
			select_in: in std_logic_vector(1 downto 0); --2 bits, 4 opciones
			data_out: out std_logic_vector(BITS-1 downto 0)
		);
	end component;

begin

	select_in(0) <= not(select_in(0)) after 20 ns;
	select_in(1) <= not(select_in(1)) after 40 ns;
	
	
	four_port_multiplexerMap: four_port_multiplexer generic map (4)
		port map(
			data_in_a => data_in_a,
			data_in_b => data_in_b,
			data_in_c => data_in_c,
			data_in_d => data_in_d,
			data_out => data_out,
			select_in => select_in
		);
		
end architecture;		
