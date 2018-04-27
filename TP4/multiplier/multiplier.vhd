library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
    port(
      op_1_in: in std_logic_vector(31 downto 0) := (others => '0');
      op_2_in: in std_logic_vector(31 downto 0) := (others => '0');
      result_out: out std_logic_vector(63 downto 0) := (others => '0')
    );

end multiplier;

architecture multiplier_arq of multiplier is

    
    begin

      process(op_1_in, op_2_in)
        variable op_1_h : unsigned(15 downto 0) := (others => '0');
        variable op_1_l : unsigned(15 downto 0) := (others => '0');
        variable op_2_h : unsigned(15 downto 0) := (others => '0');
        variable op_2_l : unsigned(15 downto 0) := (others => '0');
        variable result_ll : unsigned(63 downto 0) := (others => '0');
        variable result_lh : unsigned(63 downto 0) := (others => '0');
        variable result_hl : unsigned(63 downto 0) := (others => '0');
        variable result_hh : unsigned(63 downto 0) := (others => '0');
      begin

        op_1_l := unsigned(op_1_in(15 downto 0));
        op_1_h := unsigned(op_1_in(31 downto 16));
        op_2_l := unsigned(op_2_in(15 downto 0));
        op_2_h := unsigned(op_2_in(31 downto 16));

        --report "OP1L: " & integer'image(to_integer(op_1_l));
        --report "OP1H: " & integer'image(to_integer(op_1_h));
        --report "OP2L: " & integer'image(to_integer(op_2_l));
        --report "OP2H: " & integer'image(to_integer(op_2_h));
        

        result_ll := "00000000000000000000000000000000" & (op_1_l * op_2_l);
        result_lh := shift_left("00000000000000000000000000000000" & (op_1_l * op_2_h), 16);
        result_hl := shift_left("00000000000000000000000000000000" & (op_1_h * op_2_l), 16);
        result_hh := shift_left("00000000000000000000000000000000" & (op_1_h * op_2_h), 32);

        --report "LL: " & integer'image(to_integer(result_ll));
        --report "LH: " & integer'image(to_integer(result_lh));
        --report "HL: " & integer'image(to_integer(result_hl));
        --report "HH: " & integer'image(to_integer(result_hh));

        result_out <= std_logic_vector(result_ll + result_lh + result_hl + result_hh);

      end process;

end architecture;