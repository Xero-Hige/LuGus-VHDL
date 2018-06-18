-- ---------------------------------------------
-- UART system to test the simple uart unit and tha VGA Char generator
-- BAUD RATE 115200
-- ---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity serial2vga_system is
port (
      clk :	in std_logic;
      rst :	in std_logic;
		ena : in std_logic;
--      Divisor :	in std_logic_vector (11 downto 0); descomentar para otras velocidades
      rx :	in std_logic;
      --tx :	out std_logic;
		led0 : out std_logic;
		led1 : out std_logic;
		led2 : out std_logic;
		led3 : out std_logic;
		led4 : out std_logic;
		led5 : out std_logic;
		led6 : out std_logic;
		led7 : out std_logic
);
	attribute loc : string;
	attribute loc of clk: signal is "C9";
	attribute loc of rst: signal is "H13";
	attribute loc of ena: signal is "D18";

	attribute loc of rx: signal is "R7";
	--attribute loc of tx: signal is "M14";

	attribute loc of led0: signal is "F12";
	attribute loc of led1: signal is "E12";
	attribute loc of led2: signal is "E11";
	attribute loc of led3: signal is "F11";
	attribute loc of led4: signal is "C11";
	attribute loc of led5: signal is "D11";
	attribute loc of led6: signal is "E9";
	attribute loc of led7: signal is "F9";
end serial2vga_system;

architecture arch of serial2vga_system is
      component UART_RX
      generic (
			g_CLKS_PER_BIT : integer := 115     -- Needs to be set correctly
		);
		port (
			i_Clk       : in  std_logic;
			i_RX_Serial : in  std_logic;
			o_RX_DV     : out std_logic;
			o_RX_Byte   : out std_logic_vector(7 downto 0)
		);
      end component;
		
      signal sig_Din	: std_logic_vector(7 downto 0);
      signal sig_Dout	: std_logic_vector(7 downto 0);
      signal sig_RxErr	: std_logic;
      signal sig_RxRdy	: std_logic;
      signal sig_TxBusy	: std_logic;
      signal sig_StartTx: std_logic;

   begin
		-- UART Instanciation :
		UUT : UART_RX
		generic map (
			g_CLKS_PER_BIT => 434
      )
		port map (
			i_clk       => clk,
			i_rx_serial => rx,
			o_rx_dv     => sig_RxRdy,
			o_rx_byte   => sig_Dout
      );
		
		process(clk)
			variable position : integer := 0;
			variable position_v : std_logic_vector(7 downto 0) := (others => '0');
		begin
			if(rising_edge(clk)) then
				if(sig_RxRdy = '1') then
					position := position + 1;
					position_v := std_logic_vector(to_unsigned(position, 8));
					led0 <= position_v(0);
					led1 <= position_v(1);
					led2 <= position_v(2);
					led3 <= position_v(3);
					led4 <= position_v(4);
					led5 <= position_v(5);
					led6 <= position_v(6);
					led7 <= position_v(7);
	--				led0 <= sig_Dout(0);
	--				led1 <= sig_Dout(1);
	--				led2 <= sig_Dout(2);
	--				led3 <= sig_Dout(3);
	--				led4 <= sig_Dout(4);
	--				led5 <= sig_Dout(5);
	--				led6 <= sig_Dout(6);
	--				led7 <= sig_Dout(7);
				end if;
			end if;
		end process;
   
   
end arch;
