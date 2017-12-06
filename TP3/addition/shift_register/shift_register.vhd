library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shift_register is
	generic(REGISTRY_BITS : integer := 32;
	 				STEPS : integer := 4);
	port(
		enable: in std_logic := '0';
		reset: in std_logic := '0';
		clk: in std_logic := '0';
		D: in std_logic_vector(REGISTRY_BITS - 1 downto 0) := (others => '0');
		Q: out std_logic_vector(REGISTRY_BITS - 1 downto 0) := (others => '0')
	);
end;

architecture shift_register_arq of shift_register is

	type inputs_array is array (natural range <>) of std_logic_vector(REGISTRY_BITS - 1 downto 0);
	signal inputs : inputs_array(STEPS downto 0) := (others => (others => '0'));

	signal enable_in : std_logic := '0';
	signal reset_in : std_logic := '0';
	signal clk_in : std_logic := '0';
	signal master_q : std_logic_vector(REGISTRY_BITS - 1 downto 0) := (others => '0');

	component registry is
		generic(TOTAL_BITS : integer := 32);
		port(
			enable: in std_logic;
			reset: in std_logic;
			clk: in std_logic;
			D: in std_logic_vector(TOTAL_BITS - 1 downto 0);
			Q: out std_logic_vector(TOTAL_BITS - 1 downto 0)
		);
  end component;

begin
	
	inputs(0) <= D;

	all_registries: for i in 0 to (STEPS - 1) generate
			reg : registry
					generic map(TOTAL_BITS => REGISTRY_BITS)
					port map(
						enable => enable_in,
						reset => reset_in,
						clk => clk_in,
						D => inputs(i),
						Q => inputs(i+1)
					);
	end generate all_registries; 

	clk_in <= clk;
	reset_in <= reset;
	enable_in <= enable;

	master_q <= inputs(STEPS);
	Q <= master_q;

end;