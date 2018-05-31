-- ---------------------------------------------
-- UART system to test the simple uart unit and tha VGA Char generator
-- BAUD RATE 115200
-- ---------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity serial2vga_system is
port (
      clk :	in std_logic;
      rst :	in std_logic;
		ena : in std_logic;
--      Divisor :	in std_logic_vector (11 downto 0); descomentar para otras velocidades
      rx :	in std_logic;
      tx :	out std_logic;
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
	attribute loc of tx: signal is "M14";

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
      component uart
      	generic (
		F: natural;
		min_baud: natural;
		num_data_bits: natural
	);
	port (
         	Rx	: in std_logic;
	 	Tx	: out std_logic;
	 	Din	: in std_logic_vector(7 downto 0);
	 	StartTx	: in std_logic;
		TxBusy	: out std_logic;
		Dout	: out std_logic_vector(7 downto 0);
		RxRdy	: out std_logic;
		RxErr	: out std_logic;
		Divisor	: in std_logic_vector; 
		clk	: in std_logic;
		rst	: in std_logic
	);
      end component;

      constant Divisor : std_logic_vector := "000000011011"; -- Divisor=27 para 115200 baudios
      signal sig_Din	: std_logic_vector(7 downto 0);
      signal sig_Dout	: std_logic_vector(7 downto 0);
      signal sig_RxErr	: std_logic;
      signal sig_RxRdy	: std_logic;
      signal sig_TxBusy	: std_logic;
      signal sig_StartTx: std_logic;

   begin
		-- UART Instanciation :
		UUT : uart
		generic map (
			F 	=> 50000,
			min_baud => 1200,
			num_data_bits => 8
		)
		port map (
			Rx	=> rx,
			Tx	=> tx,
			Din	=> sig_Din,
			StartTx	=> sig_StartTx,
			TxBusy	=> sig_TxBusy,
			Dout	=> sig_Dout,
			RxRdy	=> sig_RxRdy,
			RxErr	=> sig_RxErr,
			Divisor	=> Divisor,
			clk	=> clk,
			rst	=> rst
		);
		
		process(sig_RxRdy)
		begin
			if(sig_RxRdy = '1') then
				led0 <= sig_Dout(0);
				led1 <= sig_Dout(1);
				led2 <= sig_Dout(2);
				led3 <= sig_Dout(3);
				led4 <= sig_Dout(4);
				led5 <= sig_Dout(5);
				led6 <= sig_Dout(6);
				led7 <= sig_Dout(7);
			end if;
		end process;
   
   
end arch;
