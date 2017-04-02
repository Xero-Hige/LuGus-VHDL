library IEEE;
use IEEE.std_logic_1164.all;


entity contador is
	port(
		rst_c: in std_logic;
		clk_c: in std_logic;
		enable_c: in std_logic;
		--Q: out std_logic_vector(1 downto 0);
		q1_c: out std_logic;
		q0_c: out std_logic
	);
end;

architecture contador_func of contador is
	component FFD is
	port(
		enable: in std_logic;
		reset: in std_logic;
		clk: in std_logic;
		Q: out std_logic;
		D: in std_logic
		);
	end component;
	
	signal q0_c_aux,q1_c_aux,d0_c_aux,d1_c_aux:std_logic;	

begin
	ffd0: FFD port map( --nombres del FFD : enable,reset,clk,Q,D
		clk => clk_c,
		enable => enable_c,
		reset => rst_c, --Siempre van a la izquierda los puertos de los componentes
		D => d0_c_aux,
		Q => q0_c_aux
		
	);
	
	q0_c <= q0_c_aux;
	
	ffd1: FFD port map(
		clk=> clk_c,
		enable => enable_c,
		reset => rst_c,
		D => d1_c_aux,
		Q => q1_c_aux
	);
	
	q1_c <= q1_c_aux;
	
	d0_c_aux <= not(q0_c_aux);
	d1_c_aux <= q1_c_aux xor q0_c_aux;
	
end architecture;

	