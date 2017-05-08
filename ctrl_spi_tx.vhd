library ieee;
use ieee.std_logic_1164.all;

entity ctrl_spi_tx is
port(
	CLK, RST_N : in std_logic;
	MODE : in std_logic_vector(1 downto 0);
	tx : out std_logic; 
   SPI_SCK   : out std_logic;
   SPI_MOSI  : out std_logic;
   SPI_MISO  : in  std_logic;
	--SHOW : out std_logic_vector(7 downto 0);
	
   SPI_SS_N  : out std_logic );

end ctrl_spi_tx;

architecture behave of ctrl_spi_tx is
component SPI_master is
  generic( WAIT_COUNT_MAX : integer := 100 ;--1/2 SPI clk period
			  data_M_to_S: integer := 4; --data send master to slave**************
			  data_S_to_M: integer := 12);--data send slave to master**************
  port(
    CLK       : in  std_logic; --clock input
    RST_N     : in  std_logic; --Reset
    START     : in  std_logic; --Start
    HOLD_SS_N : in  std_logic; --status CS logic before active 
    WDATA     : in  std_logic_vector( data_M_to_S-1 downto 0 ); --data writed master to slave 
    RDATA     : out std_logic_vector( data_S_to_M-1 downto 0 ) := (others => '0'); --data resived slave to master 
    DONE      : out std_logic; --
    -- SPI interface
    SPI_SCK   : out std_logic;
    SPI_MOSI  : out std_logic;
    SPI_MISO  : in  std_logic;
    SPI_SS_N  : out std_logic );
end component;

component rs232_tx is
  generic(
    SYSTEM_SPEED : integer := 50e6;   	-- clock speed, in Hz
    BAUDRATE     : integer :=9600);  	-- baudrate
  port(
    clk_i  : in  std_logic;   -- system clock
    rst_i  : in  std_logic; 	-- synchronous reset, active-Low
    req_i  : in  std_logic; 	-- Tx request 
    ack_o  : out std_logic; 	-- Tx acknowledge
    data_i : in  std_logic_vector(7 downto 0); -- Tx data
    tx     : out std_logic ); 	-- Tx output 
end component;

component controller_Spi_tx is
port(
	CLK, RST_N : in std_logic;
	--RX
	MODE : in std_logic_vector(1 downto 0);
	
	-- SPI
	voltage_in : in std_logic_vector(11 downto 0);
	MOSI : out std_logic_vector(3 downto 0);
	START : out std_logic:='0';
	DONE 	: in std_logic;
	
	--TX
	data_to_tx : out std_logic_vector(7 downto 0);
	request_tx : out std_logic:='0';
	ack_form_tx : in std_logic);
end component;


	signal HOLD_SS_N : std_logic:='1'; -- status CS logic before active 
	signal WDATA     : std_logic_vector( 3 downto 0 ); -- data writed master to slave 
	signal RDATA     : std_logic_vector( 11 downto 0 ) := (others => '0'); -- data resived slave to master 
	signal DONE, START, request, ack, to_tx     : std_logic;
	signal data_to_tx : std_logic_vector(7 downto 0);
	begin
		--SHOW(1 downto 0) <= MODE;
		--SHOW(7  downto 4) <= WDATA;
		--SHOW2 <= ack;
		SPI:SPI_master
			port map(CLK, RST_N, START, HOLD_SS_N, WDATA, RDATA, DONE, SPI_SCK, SPI_MOSI, SPI_MISO, SPI_SS_N);
		rsTX:rs232_tx
			port map(CLK, RST_N, request, ack, data_to_tx, to_tx);
		Ctrl:controller_Spi_tx
			port map(CLK, RST_N, MODE, RDATA, WDATA, START, DONE, data_to_tx, request, ack);
		tx<=to_tx;
		--SHOW2 <= to_tx;
end behave;