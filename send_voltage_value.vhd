library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity send_voltage_value is
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
	--check : out std_logic_vector(7 downto 0);
	request_tx : out std_logic:='0';
	ack_form_tx : in std_logic);
end send_voltage_value;


architecture behave of send_voltage_value is
constant SEND_PER_SEC : integer := 6000;
signal MAX_COUNTER : integer := 50e6/SEND_PER_SEC;

constant VOLTAGE_REFER : integer := 3300;

   type state_type is (
        WAIT_TIME_REQ,	-- Default state
		  
		  --MODE SINGLE
		  REQ_VOLTAGE_SINGLE,
		  WAIT_DONE_SINGLE,
		  
		  SEND_MODE_SINGLE,
		  WAIT_SEND_MODE_SINGLE,
		  
		  SEND_VOLTAGE_PART1_SINGLE,
		  WAIT_SEND_VOLTAGE_PART1_SINGLE,
		  SEND_VOLTAGE_PART2_SINGLE,
		  WAIT_SEND_VOLTAGE_PART2_SINGLE,
		  
		  --MODE DUAL
		  REQ_VOLTAGE_CH1_DUAL,
		  WAIT_DONE_CH1_DUAL,
		  REQ_VOLTAGE_CH2_DUAL,
		  WAIT_DONE_CH2_DUAL,
		  
		  SEND_MODE_DUAL,
		  WAIT_SEND_MODE_DUAL,
		  
		  SEND_VOLTAGE_CH1_PART1_DUAL,
		  WAIT_SEND_VOLTAGE_CH1_PART1_DUAL,
		  SEND_VOLTAGE_CH1_PART2_DUAL,
		  WAIT_SEND_VOLTAGE_CH1_PART2_DUAL,
		  
		  SEND_VOLTAGE_CH2_PART1_DUAL,
		  WAIT_SEND_VOLTAGE_CH2_PART1_DUAL,
		  SEND_VOLTAGE_CH2_PART2_DUAL,
		  WAIT_SEND_VOLTAGE_CH2_PART2_DUAL);
		  
  signal state: state_type := WAIT_TIME_REQ;
  
  signal count_time, voltage_data, voltage_data2 : integer :=0;
  signal mode_buffer, mode_fack : std_logic_vector(1 downto 0):="00";
  signal voltage_buffer : std_logic_vector(11 downto 0);
  
begin
process(CLK) begin
	if rising_edge(CLK) then
		count_time <= count_time + 1; 
		
		case state is		
			when WAIT_TIME_REQ =>
				request_tx <= '1';
				START <= '0';
				mode_buffer <= MODE;  -- update MODE_buffer
				
				if count_time > MAX_COUNTER then				
					count_time <= 0;
				
					-- IF Single mode
					if mode_buffer = "01" or mode_buffer = "10" then
						state	<= REQ_VOLTAGE_SINGLE;
						
					-- IF Dual mode
					elsif mode_buffer = "11" then
						state <= REQ_VOLTAGE_CH1_DUAL;
					end if;
				end if;
				
----------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------	
		  --MODE SINGLE
			when REQ_VOLTAGE_SINGLE =>
				START <= '1';
				if MODE = "01" then
					MOSI <= "1101";
				elsif MODE = "10" then
					MOSI <= "1111";
				end if;
				state <=	WAIT_DONE_SINGLE;
				
			when WAIT_DONE_SINGLE =>
				START <= '0';
				if DONE = '1' then
					voltage_data <= to_integer(unsigned(voltage_in)) * VOLTAGE_REFER / 4095;
					state <= SEND_MODE_SINGLE;
				end if;
				
----------------------------------------------------------------------------------------	
			when SEND_MODE_SINGLE =>
				data_to_tx <= "100000" & mode_buffer;
				request_tx <= '0';
				state <= WAIT_SEND_MODE_SINGLE;
				
			when WAIT_SEND_MODE_SINGLE =>
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_PART1_SINGLE;
				end if;
			---------------------------------
			when SEND_VOLTAGE_PART1_SINGLE =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data/100, 8));	
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_PART1_SINGLE;
				
			when WAIT_SEND_VOLTAGE_PART1_SINGLE =>
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_PART2_SINGLE;	
				end if;
			--
			when SEND_VOLTAGE_PART2_SINGLE =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data mod 100, 8));
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_PART2_SINGLE;
				
			when WAIT_SEND_VOLTAGE_PART2_SINGLE =>	
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= WAIT_TIME_REQ;	
				end if;
				
----------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------
			--MODE DUAL
			when REQ_VOLTAGE_CH1_DUAL =>		-- Request Voltage from SPI
				MOSI <= "1101";
				START <= '1';
				if DONE = '0' then
					state <= WAIT_DONE_CH1_DUAL;
				end if;
				
			when WAIT_DONE_CH1_DUAL =>			-- 
				START <= '0';
				if DONE = '1' then
					voltage_data <= to_integer(unsigned(voltage_in)) * VOLTAGE_REFER / 4095;
					state <= REQ_VOLTAGE_CH2_DUAL;
				end if;
				
			when REQ_VOLTAGE_CH2_DUAL =>
				MOSI <= "1111";
				START <= '1';
				if DONE = '0' then
					state <= WAIT_DONE_CH2_DUAL;
				end if;
			when WAIT_DONE_CH2_DUAL =>
				START <= '0';
				if DONE = '1' then
					voltage_data2 <= to_integer(unsigned(voltage_in)) * VOLTAGE_REFER / 4095;
					state <= SEND_MODE_DUAL;
				end if;
				
----------------------------------------------------------------------------------------
			when SEND_MODE_DUAL =>
				data_to_tx <= "100000" & mode_buffer;
				request_tx <= '0';
				state <= WAIT_SEND_MODE_DUAL;
				
			when WAIT_SEND_MODE_DUAL =>
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_CH1_PART1_DUAL;
				end if;
		  
----------------------------------------------------------------------------------------
			when SEND_VOLTAGE_CH1_PART1_DUAL =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data/100, 8));	
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_CH1_PART1_DUAL;
				
			when WAIT_SEND_VOLTAGE_CH1_PART1_DUAL =>
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_CH1_PART2_DUAL;	
				end if;
				
			when SEND_VOLTAGE_CH1_PART2_DUAL =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data mod 100, 8));	
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_CH1_PART2_DUAL;
				
			when WAIT_SEND_VOLTAGE_CH1_PART2_DUAL =>  
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_CH2_PART1_DUAL;	
				end if;
		  
----------------------------------------------------------------------------------------
			when SEND_VOLTAGE_CH2_PART1_DUAL =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data2/100, 8));	
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_CH2_PART1_DUAL;
				
			when WAIT_SEND_VOLTAGE_CH2_PART1_DUAL =>
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= SEND_VOLTAGE_CH2_PART2_DUAL;	
				end if;
				
			when SEND_VOLTAGE_CH2_PART2_DUAL =>
				data_to_tx <= std_logic_vector(to_unsigned(voltage_data2 mod 100, 8));	
				request_tx <= '0';
				state <= WAIT_SEND_VOLTAGE_CH2_PART2_DUAL;
				
			when WAIT_SEND_VOLTAGE_CH2_PART2_DUAL =>  
				request_tx <= '1';
				if ack_form_tx = '1' then
					state <= WAIT_TIME_REQ;	
				end if;
		
		end case;
	end if;

end process;
end behave;