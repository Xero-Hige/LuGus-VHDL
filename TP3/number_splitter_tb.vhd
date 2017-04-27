library ieee;
use ieee.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_standalone is
	generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture number_splitter_tb_arq of tb_standalone is

	signal number_in: std_logic_vector(22 downto 0) := (others => '1');
	signal sign_out: std_logic;
	signal exp_out: std_logic_vector(5 downto 0) := (others => '0');
	signal mant_out: std_logic_vector(15 downto 0) := (others => '0');


	component number_splitter is
		generic(
			TOTAL_BITS:natural := 23;
			EXP_BITS:natural := 6);
		port (

			number_in: in std_logic_vector(TOTAL_BITS-1 downto 0);
			sign_out: out std_logic;
			exp_out: out std_logic_vector(EXP_BITS-1 downto 0);
			mant_out: out std_logic_vector(TOTAL_BITS - EXP_BITS - 2 downto 0)
		);
	end component;

begin
	type pattern_type is record
		 --  The inputs of the adder.
		 i0, i1, ci : std_logic_vector;
		 --  The expected outputs of the adder.
		 s, co : bit;
	end record;
	--  The patterns to apply.
	type pattern_array is array (natural range <>) of pattern_type;
	constant patterns : pattern_array :=
		(('0', '0', '0', '0', '0'),
		 ('0', '0', '1', '1', '0'),
		 ('0', '1', '0', '1', '0'),
		 ('0', '1', '1', '0', '1'),
		 ('1', '0', '0', '1', '0'),
		 ('1', '0', '1', '0', '1'),
		 ('1', '1', '0', '0', '1'),
		 ('1', '1', '1', '1', '1'));

	number_splitter_map: number_splitter port map(
			number_in => number_in,
			sign_out => sign_out,
			exp_out => exp_out,
			mant_out => mant_out
		);

	info("===EXP===" & LF & to_string(exp_out));
	info("===MAN===" & LF & to_string(mant_out));
	info("===SIG===" & LF & to_string(sign_out));


end architecture;
