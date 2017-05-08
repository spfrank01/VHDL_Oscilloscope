library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity rs232_rx is
	generic(
		system_speed : integer := 50e6;		-- clock speed, in Hz
		baudrate		 : integer := 115200);		--	baudrate
	port(
		clk_i			: in	std_logic;	-- system clock
      req_o : out std_logic;
		rst_i			: in	std_logic;	-- synchronous reset, active high
		data_o		: out std_logic_vector(7 downto 0);	--	Rx data
		rx				: in	std_logic);	-- Rx input
end rs232_rx;

architecture behave of rs232_rx is
	constant max_count: integer := (system_speed/baudrate);
	type state_type is (
		wait_for_rx_start,
		wait_half_bit,
		receive_bits,
		wait_for_stop_bit);
	
	signal state : state_type := wait_for_rx_start;
	signal baudrate_counter : integer range 0 to max_count := 0;
	signal bit_counter : integer range 0 to 7 := 0;
	signal shift_register : std_logic_vector(7 downto 0) := (others => '0');
	
begin
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			if rst_i = '0' then
				state <= wait_for_rx_start;
				data_o <= (others => '0');
				req_o <= '1';
			else
				case state is
					when wait_for_rx_start =>
						req_o <= '1';
						if rx = '0' then
							-- start bit received, wait for a half bit time
							-- to sample bits in the middle of the signal
							state <= wait_half_bit;
							baudrate_counter <= (max_count/2)-1;
						end if;
						
					when wait_half_bit =>
						if baudrate_counter = 0 then
							-- now we are in the middle of the start bit,
							-- wait a full bit for the middle of the first bit
							state <= receive_bits;
							bit_counter <= 7;
							baudrate_counter <= max_count-1;
						else
							baudrate_counter <= baudrate_counter-1;
						end if;
						
					when receive_bits =>
						-- sample a bit
						if baudrate_counter = 0 then
							shift_register <= rx & shift_register(7 downto 1);
							if bit_counter = 0 then
								state <= wait_for_stop_bit;
							else
								bit_counter <= bit_counter-1;
							end if;
							baudrate_counter <= max_count-1;
						else
							baudrate_counter <= baudrate_counter-1;
						end if;
						
					when wait_for_stop_bit =>
						-- wait for the middle of the stop bit
						if baudrate_counter = 0 then
							state <= wait_for_rx_start;
							if rx = '1' then
								data_o <= shift_register;
								req_o <= '0';
								-- else: missing stop bit, ignore
							end if;
						else
							baudrate_counter <= baudrate_counter-1;
						end if;
				end case;
			end if;
		end if;
	end process;
	
end behave;	