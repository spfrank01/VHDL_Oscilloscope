library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VHDL_Oscilloscope is
port(
	CLK, RST_N, rx :in std_logic;
	tx : out std_logic;
	
	-- LCD Module
	LCD_E  : out std_logic;
	LCD_RS : out std_logic;
	LCD_RW : out std_logic;
	LCD_DB : out std_logic_vector(7 downto 4);
	
	--SPI module
	SPI_SCK   : out std_logic;
	SPI_MOSI : out std_logic;
	SPI_MISO  : in  std_logic;		
	SPI_SS_N  : out std_logic );

end VHDL_Oscilloscope;

architecture behave of VHDL_Oscilloscope is

	component LCD_Control is
		port( CLK    : in std_logic;
				RST_N  : in  std_logic; -- Reset
				RX		 : in std_logic;
				-- LCD Module
				LCD_E  : out std_logic;
				LCD_RS : out std_logic;
				LCD_RW : out std_logic;
				LCD_DB : out std_logic_vector(7 downto 4);
				
				mode_data : out std_logic_vector(1 downto 0));
	end component;

	component ctrl_spi_tx is
	port(
		CLK, RST_N : in std_logic;
		MODE : in std_logic_vector(1 downto 0);
		tx : out std_logic; 
		--SPI module
		SPI_SCK   : out std_logic;
		SPI_MOSI : out std_logic;
		SPI_MISO  : in  std_logic;		
		SPI_SS_N  : out std_logic );
	end component;
	signal mode_data : std_logic_vector(1 downto 0);
	begin
		CtrlLcdRx : LCD_Control
			port map(CLK, RST_N, rx, LCD_E, LCD_RS, LCD_RW, LCD_DB, mode_data);
		CtrlSpiTx : ctrl_spi_tx
			port map(CLK, RST_N, mode_data, tx, SPI_SCK, SPI_MOSI, SPI_MISO,SPI_SS_N);

end behave;