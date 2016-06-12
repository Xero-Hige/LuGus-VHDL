library ieee;
use ieee.std_logic_1164.all;

entity bcd_controller is
	port(
		rst: in  std_logic;
		clk: in std_logic;		
		anod_out: out std_logic_vector(3 downto 0);
		a: out std_logic;
		b: out std_logic;
		c: out std_logic;
		d: out std_logic;
		e: out std_logic;
		f: out std_logic;
		g: out std_logic;
		dp: out std_logic
		
	);
	
	attribute LOC  : string;
	
	attribute LOC of clk: signal is "B8";
	attribute LOC of anod_out: signal is "F15 C18 H17 F17";
	
	attribute LOC of rst: signal is "B18";
	
	attribute LOC of a: signal is "L18";
	attribute LOC of b: signal is "F18";
	attribute LOC of c: signal is "D17";
	attribute LOC of d: signal is "D16";
	attribute LOC of e: signal is "G14";
	attribute LOC of f: signal is "J17";
	attribute LOC of g: signal is "H14";
	attribute LOC of dp: signal is "C17";
	
end entity;
	
	
architecture bcd_controller_arq of bcd_controller is	
	signal multiplexer_to_decoder: std_logic_vector(3 downto 0); --Signal from counter multiplexer to bcd decoder
	signal anod_enabler_to_anod_counter: std_logic; --Connects anod enabler output with anod counter to control counting frequence
	signal anod_counter_to_multiplexer: std_logic_vector(1 downto 0); --Connects anod counter with bcd multiplexer
	signal c_out0: std_logic;
	signal c_out1: std_logic;
	signal c_out2: std_logic;
	signal counter_enabler_to_bcd_counter: std_logic;
	signal counter_to_mp0: std_logic_vector(3 downto 0);
	signal counter_to_mp1: std_logic_vector(3 downto 0);
	signal counter_to_mp2: std_logic_vector(3 downto 0);
	signal counter_to_mp3: std_logic_vector(3 downto 0);
	
	--Needed to make de AND work
	signal ena_to_bcd_counter1: std_logic; 
	signal ena_to_bcd_counter2: std_logic; 
	signal ena_to_bcd_counter3: std_logic;
	--Para contar y activar los anodos
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
	
	--Para multiplexar las entradas
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
	
	--Para regular la frecuencia en la que se activan los anodos
	component generic_enabler is
		generic(PERIOD:natural := 1000000 ); --1MHz
		port(
			clk: in std_logic;
			rst: in std_logic;
			ena_out: out std_logic
		);
	end component;
	
	component contBCD is
		port (
			clk: in std_logic;
			rst: in std_logic;
			ena: in std_logic;
			s: out std_logic_vector(3 downto 0);
			co: out std_logic
		);
	end component;
	

	--Para decodificar la entrada
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
	
	--To decode from binary to anod code
	component anod_enabler_decoder is
		port(
			binary_in: in std_logic_vector(1 downto 0); --"2 bit vector to switch between the 4 possible anod values"
			code_out: out std_logic_vector(3 downto 0) --4 bit output to switch between anod
		);
	end component;


begin
	
	ena_to_bcd_counter1 <= c_out0 AND counter_enabler_to_bcd_counter; 
	ena_to_bcd_counter2 <= c_out1 AND ena_to_bcd_counter1;
	ena_to_bcd_counter3 <= c_out2 AND ena_to_bcd_counter2;
	
	--Need one counter to count between the anods
	anodCounter: genericCounter generic map (2,3) --2 bits, cuenta hasta 3
		port map(
			clk => anod_enabler_to_anod_counter,
			rst => '0',
			ena => '1',
			--carry_o => '0',  --El count_dummy esta conectado siempre a tierra.
			count => anod_counter_to_multiplexer
		);
	
	--Need one decoder to decode from binary to anod code
	anodEnablerDecoder: anod_enabler_decoder
		port map(
			binary_in => anod_counter_to_multiplexer,
			code_out => anod_out
		);

	--Need one enabler to control the speed of anod switching
	anodEnabler: generic_enabler generic map (300)
		port map(
			clk => clk,
			rst => '0',
			ena_out => anod_enabler_to_anod_counter
		);


	--Need a generic enabler to control count frequency
	counterEnabler: generic_enabler generic map (50000000) --50MHz
		port map(
			clk => clk,
			rst => rst,
			ena_out => counter_enabler_to_bcd_counter
		);



	--Need 4 bcd counters
	bcdCounter0: contBCD 
		port map(
			clk => clk,
			rst => rst,
			ena => counter_enabler_to_bcd_counter, --The input is generated by the enabler
			s => counter_to_mp0,
			co => c_out0
		);

	bcdCounter1: contBCD 
		port map(
			clk => clk,
			rst => rst,
			ena => ena_to_bcd_counter1,
			s => counter_to_mp1,
			co => c_out1
		);

	bcdCounter2: contBCD
		port map(
			clk => clk,
			rst => rst,
			ena => ena_to_bcd_counter2,
			s => counter_to_mp2,
			co => c_out2
		);

	bcdCounter3: contBCD
		port map(
			clk => clk,
			rst => rst,
			ena => ena_to_bcd_counter3,
			s => counter_to_mp3
			--co
		);


	--Need a multiplexer to switch between the bcd counters
	bcdCounterMultiplexer: four_port_multiplexer generic map (4) --4 bits inputs
		port map(
			data_in_a => counter_to_mp0,
			data_in_b => counter_to_mp1,
			data_in_c => counter_to_mp2,
			data_in_d => counter_to_mp3,
			select_in => anod_counter_to_multiplexer,
			data_out => multiplexer_to_decoder
		); 

	decoBCDMap: decoBCD 
		port map(
			ena => '1',
			count => multiplexer_to_decoder,
			a => a,
			b => b,
			c => c,
			d => d,
			e => e, 
			f => f,
			g => g,
			dp => dp
			--anod => not('1') --siempre activado
		);
	
			
	
		
	
end;		