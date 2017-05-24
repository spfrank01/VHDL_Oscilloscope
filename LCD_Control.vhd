library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_Control is
	port( CLK    : in std_logic;
			RST_N  : in  std_logic; -- Reset
			RX		 : in std_logic;
         -- LCD Module
			LCD_E  : out std_logic;
			LCD_RS : out std_logic;
			LCD_RW : out std_logic;
			LCD_DB : out std_logic_vector(7 downto 4);
			
			mode_data : out std_logic_vector(1 downto 0));
end LCD_Control;

architecture behavior of LCD_Control is
	component Control is
	port (
			CLK : in std_logic;
			req_i : in std_logic;
	      rst_i  : in	 std_logic;		-- synchronous reset, active low
			mode_data : out std_logic_vector(1 downto 0);
			sleep : out std_logic:='0';
			DATA_IN : in std_logic_vector(7 downto 0));
	end component;
	
	component lcd16x2_ctrl_demo3 is
		port (
			clk, sleep    : in  std_logic;
			data_in : in std_logic_vector(11 downto 0);
			mode_select : in std_logic_vector(1 downto 0);
			lcd_e  : out std_logic;
			lcd_rs : out std_logic;
			lcd_rw : out std_logic;
			lcd_db : out std_logic_vector(7 downto 4));
	end component;
	
	component rs232_rx is
		generic(
			SYSTEM_SPEED : integer := 50e6;
			BAUDRATE		 : integer := 115200);
		port(	clk_i		: in	std_logic;	-- system clock
				rst_i		: in	std_logic;	-- synchronous reset, active high
				req_o		: out	std_logic := '0';		-- Rx req	
				data_o	: out std_logic_vector(7 downto 0);	--	Rx data
				rx			: in	std_logic);	-- Rx input
	end component;
	
	signal mode_data_lcd : std_logic_vector(1 downto 0);
	signal channel_data : std_logic_vector(3 downto 0);
	signal signal_data : std_logic_vector(11 downto 0);
	signal data_temp : std_logic_vector(7 downto 0);
	signal rx_out : std_logic;
	signal start_spi : std_logic;
	signal done_spi : std_logic;
	signal HOLD_SS_N : std_logic; -- status CS logic before active
	signal sleep : std_logic;
	
	begin
		U0:Control
			port map(CLK, rx_out, RST_N, mode_data_lcd, sleep, data_temp);
		U1:lcd16x2_ctrl_demo3
			port map(CLK, sleep, signal_data, mode_data_lcd, LCD_E, LCD_RS, LCD_RW, LCD_DB);
		U2:rs232_rx
			port map(CLK, RST_N, rx_out, data_temp, RX);
		mode_data <= mode_data_lcd;
end behavior;