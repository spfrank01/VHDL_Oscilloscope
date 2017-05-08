library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rs232_tx is
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
end rs232_tx;

architecture behave of rs232_tx is
   constant MAX_COUNTER: integer := (SYSTEM_SPEED / BAUDRATE);
   type state_type is (
        WAIT_FOR_REQ,
        SEND_START_BIT,
        SEND_BITS,
        SEND_STOP_BIT);
  signal state: state_type := WAIT_FOR_REQ;
  signal baudrate_counter: integer range 0 to MAX_COUNTER := 0;
  signal bit_counter : integer range 0 to 7 := 0;
  signal shift_reg   : std_logic_vector(7 downto 0) := (others => '0');
  signal data_sending_started: std_logic := '0';
  --signal carry : std_logic:= '0';
begin
  -- acknowledge, when sending process was started
  --ack_o <= data_sending_started and (not req_i);

update: process(clk_i)
        begin
        if rising_edge(clk_i) then
             if rst_i = '0' then
                tx <= '1';
                data_sending_started <= '0';
                state <= WAIT_FOR_REQ;
              else
              case state is
              -- wait until the master asserts valid data
                  when WAIT_FOR_REQ =>
							
							 ack_o <= '0';
                      if req_i = '0' then
							 --if req_i = '0' and carry= '0' then
							    --carry <= '1';
                         state <= SEND_START_BIT;
                         baudrate_counter <= MAX_COUNTER - 1;
                         tx <= '0';
                         shift_reg <= data_i;
                         data_sending_started <= '1';
                      --elsif req_i = '1' and carry = '1' then
							   --carry <= '0';
                      else  
								tx <= '1';
                      end if;
                  when SEND_START_BIT =>
                      if baudrate_counter = 0 then
                         state <= SEND_BITS;
                         baudrate_counter <= MAX_COUNTER - 1;
                         tx <= shift_reg(0); -- send LSB first
                         bit_counter <= 7;
                      else
                         baudrate_counter <= baudrate_counter - 1;
                      end if;
                  when SEND_BITS =>
                      if baudrate_counter = 0 then
                         if bit_counter = 0 then
                            state <= SEND_STOP_BIT;
                            tx <= '1';
                         else
                           tx <= shift_reg(1); -- send next bit
                           shift_reg <= '0' & shift_reg(7 downto 1);
                           bit_counter <= bit_counter - 1;
                         end if;
                         baudrate_counter <= MAX_COUNTER - 1;
                      else
                         baudrate_counter <= baudrate_counter - 1;
                      end if;
                  when SEND_STOP_BIT =>
                      if baudrate_counter = 0 then
								 ack_o <= '1';
                         state <= WAIT_FOR_REQ;
                      else
                         baudrate_counter <= baudrate_counter - 1;
                      end if;
               end case;

        -- this resets acknowledge until all bits are sent.
        if req_i = '1' and data_sending_started = '1' then
          data_sending_started <= '0';
        end if;
      end if;
    end if;
  end process;
  
end behave;
------------------------------------------------------------------------------
