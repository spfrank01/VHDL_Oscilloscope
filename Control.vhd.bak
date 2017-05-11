library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
entity Control is
	port (
			CLK : in std_logic;
			req_i : in std_logic;
	      rst_i  : in	 std_logic;		-- synchronous reset, active low
			mode_data : out std_logic_vector(1 downto 0);
			DATA_IN : in std_logic_vector(7 downto 0));
end Control;

architecture behave of Control is
	signal channel_tem : std_logic_vector(3 downto 0);
	type state_type is (
		check_start_bit,
		check_mode_bit);
	signal state : state_type := check_start_bit;
	begin
		process(CLK, req_i, rst_i)
			begin
         if rst_i = '0' then
				state <= check_start_bit;
			elsif rising_edge(CLK)then
				case state is
					when check_start_bit =>
					
						if req_i = '0' and Data_IN = x"23" then
							state <= check_mode_bit;
						end if;
					
					when check_mode_bit =>
					
						if req_i = '0' then
							 if DATA_IN = x"30" then  -- 1 ascii
								 mode_data <= "00";
								 state <= check_start_bit;
								 
							 elsif DATA_IN = x"31" then
								 mode_data <= "01";
							    state <= check_start_bit;
								 
							 elsif DATA_IN = x"32" then
							    mode_data <= "10";
							    state <= check_start_bit;
								 
							 elsif DATA_IN = x"33" then
							    mode_data <= "11";
							    state <= check_start_bit;
							 end if;
						end if;
						
				end case;
			end if;
		end process;
end behave;