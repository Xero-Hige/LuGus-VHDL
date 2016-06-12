library ieee;
use ieee.std_logic_1164.all;

entity decoBCD_tb is
end;

architecture decoBCD_tb_func of decoBCD_tb is
	
	--Contador
	signal rst_in: std_logic:='1';
	signal enable_in: std_logic:='0';
	signal clk_in: std_logic:='0';
	
	--Conexiones
	signal counter_to_deco: std_logic_vector(3 downto 0) := (others => '0');
	
	--Deco
	signal anod_out: std_logic:='1';
	signal n_out: std_logic_vector(7 downto 0) := (others => '0');
	signal c_out: std_logic:='0';
	
	
	component contBCD is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			s: out std_logic_vector(3 downto 0);
			co: out std_logic
		);
	end component;
	
	component decoBCD is
		port(
		ena: in std_logic; --Estara conectado al anodo del BCD para habilitarlo o no
		count: in std_logic_vector(3 downto 0); --Bits del contador
		a: out std_logic;
		b: out std_logic;
		c: out std_logic;
		d: out std_logic;
		e: out std_logic;
		f: out std_logic;
		g: out std_logic;
		dp: out std_logic;
		anod: out std_logic
		);
	end component;
begin

	clk_in <= not(clk_in) after 20 ns;
	rst_in <= '0' after 50 ns;
	enable_in <= '1' after 60 ns;
	
	contadorBCDMap: contBCD port map(
	
		clk => clk_in,
		rst => rst_in,
		ena => enable_in,
		s => counter_to_deco,
		co => c_out
	);
	
	decoBCDMap: decoBCD port map(
		
		a => n_out(7),
		b => n_out(6),
		c => n_out(5),
		d => n_out(4),
		e => n_out(3),
		f => n_out(2),
		g => n_out(1),
		dp => n_out(0),
		ena => enable_in,
		count => counter_to_deco
	
	);
		
end architecture;		
