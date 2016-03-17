library ieee;
use ieee.std_logic_1164.all;

entity generic_enabler is
	generic(PERIOD:natural := 1000000 ); --1MHz
	port(
		clk: in std_logic;
		rst: in std_logic;
		ena_out: out std_logic
	);
end;
	
	
architecture generic_enabler_arq of generic_enabler is	
	signal rst_in: std_logic:='0';
	signal enable_in: std_logic:='1';
	signal clk_in: std_logic:='0';
	signal enable_out: std_logic:='0';
	
	component genericCounter is
		generic (
			BITS:natural := 4;
			MAX_COUNT:natural := 15);
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			count: out std_logic_vector(BITS-1 downto 0);
			carry_o: out std_logic
		);
	end component;

begin
	genericCounterMap: genericCounter generic map (32,PERIOD/2) --32 bits son suficientes para hasta 4 GHz
		port map(
			clk => clk_in,
			rst => rst_in,
			ena => enable_in,
			carry_o => enable_out); --El count_dummy esta conectado siempre a tierra.
		
	clk_in <= clk;
	rst_in <= rst;
	ena_out <= enable_out;
end;		