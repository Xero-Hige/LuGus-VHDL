library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

package utility is
	type bcd_vector is array (natural range <>) of std_logic_vector(3 downto 0);
	type signal_vector is array(natural range <>) of std_logic;
end;