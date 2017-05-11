-------------------------------------------------------------------------------
-- Title      : Synthesizable demo for design "lcd16x2_ctrl"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : lcd16x2_ctrl_tb.vhd
-- Author     :   <stachelsau@T420>
-- Company    : 
-- Created    : 2012-07-28
-- Last update: 2012-07-29
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: This demo writes writes a "hello world" to the display and
-- interchanges both lines periodically.
-------------------------------------------------------------------------------
-- Copyright (c) 2012 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-07-28  1.0      stachelsau      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


-------------------------------------------------------------------------------

entity lcd16x2_ctrl_demo3 is
  port (
    clk    : in  std_logic;
	 data_in : in std_logic_vector(11 downto 0);
	 mode_select : in std_logic_vector(1 downto 0);
    lcd_e  : out std_logic;
    lcd_rs : out std_logic;
    lcd_rw : out std_logic;
    lcd_db : out std_logic_vector(7 downto 4));

end entity lcd16x2_ctrl_demo3;

-------------------------------------------------------------------------------

architecture behavior of lcd16x2_ctrl_demo3 is

  -- 
  signal timer : natural range 0 to 100000000 := 0;
  signal switch_lines : std_logic := '0';
  signal line1 : std_logic_vector(127 downto 0);
  signal line2 : std_logic_vector(127 downto 0);
  

  -- component generics
  constant CLK_PERIOD_NS : positive := 10;  -- 100 Mhz

  -- component ports
  signal rst          : std_logic;
  signal line1_buffer : std_logic_vector(127 downto 0);
  signal line2_buffer : std_logic_vector(127 downto 0);
  
  -- value of input
  signal data_buffer : std_logic_vector(7 downto 0) := X"31";
  signal count : integer range 0 to 10 := 0;
  signal status1_line1 : std_logic_vector(7 downto 0);
  signal bit_to_int : Integer;
  signal value_form_read : Integer;
  signal data : Integer;
  signal first_bit : Integer;
  signal second_bit : Integer;
  signal third_bit : Integer;
  --signal data_buffer : std_logic_vector(3 downto 0) := "1101";
  signal f : std_logic_vector(7 downto 0);
  signal s : std_logic_vector(7 downto 0);
  signal t : std_logic_vector(7 downto 0);
  signal ff : std_logic_vector(7 downto 0);
  signal ss : std_logic_vector(7 downto 0);
  signal tt : std_logic_vector(7 downto 0);
  
  signal status1 : std_logic_vector(7 downto 0);
  signal status2 : std_logic_vector(7 downto 0);
  signal status3 : std_logic_vector(7 downto 0);
  signal status4 : std_logic_vector(7 downto 0);
  signal status5 : std_logic_vector(7 downto 0);
  signal status6 : std_logic_vector(7 downto 0);
  
begin  -- architecture behavior

  -- component instantiation
  DUT : entity work.lcd16x2_ctrl
    generic map (
      CLK_PERIOD_NS => CLK_PERIOD_NS)
    port map (
      clk          => clk,
      rst          => rst,
      lcd_e        => lcd_e,
      lcd_rs       => lcd_rs,
      lcd_rw       => lcd_rw,
      lcd_db       => lcd_db,
      line1_buffer => line1_buffer,
      line2_buffer => line2_buffer);

   rst <= '0';
   bit_to_int <= to_integer(unsigned(data_in)) * 330;
	data <= bit_to_int/4095;
	first_bit  <= data/100 + 48;
	second_bit <= ((data /10) - (data/100)*10) + 48;
	third_bit  <= (data mod 10) + 48;
	
	f <=  std_logic_vector(to_unsigned(first_bit, 8));	
	s <=  std_logic_vector(to_unsigned(second_bit, 8));	
	t <=  std_logic_vector(to_unsigned(third_bit, 8));

  -- switch lines every second
  process(clk)
  begin
    if rising_edge(clk) then
	
      if timer = 0 then
			timer <= 25000000;
			
			if mode_select = "00" then
		
				status1 <= X"4f";
				status2 <= X"46";
				status3 <= X"46";
				
				status4 <= X"4f";
				status5 <= X"46";
				status6 <= X"46";
				
				line1(127 downto 120) <= X"43";  -- C
				line1(119 downto 112) <= X"48";  -- H
				line1(111 downto 104) <= X"31";  -- 1
				line1(103 downto 96)  <= X"3a";  -- :
				line1(95 downto 88)   <= status1;  -- O
				line1(87 downto 80)   <= status2;  -- N or F
				line1(79 downto 72)   <= status3;  -- " " or F
				line1(71 downto 64)   <= X"20";  -- " "
				line1(63 downto 56)   <= X"43";  -- C
				line1(55 downto 48)   <= X"48";  -- H
				line1(47 downto 40)   <= X"32";  -- 2
				line1(39 downto 32)   <= X"3a";  -- :
				line1(31 downto 24)   <= status4;  -- O
				line1(23 downto 16)   <= status5;  -- N or F
				line1(15 downto 8)    <= status6;  -- " " or F
				line1(7 downto 0)     <= X"20";  -- " "	
			
				line2(127 downto 120) <= X"43";  -- C
				line2(119 downto 112) <= X"48";  -- H
				line2(111 downto 104) <= X"31";  -- 1
				line2(103 downto 96)  <= X"3a";  -- :
				line2(95 downto 88)   <= X"20";  -- " "
				line2(87 downto 80)   <= X"2e";  -- .
				line2(79 downto 72)   <= X"20";  -- " "
				line2(71 downto 64)   <= X"20";  -- " "
				line2(63 downto 56)   <= X"43";  -- C
				line2(55 downto 48)   <= X"48";  -- H
				line2(47 downto 40)   <= X"32";  -- 2
				line2(39 downto 32)   <= X"3a";  -- :
				line2(31 downto 24)   <= X"20";  -- " "
				line2(23 downto 16)   <= X"2e";  -- .
				line2(15 downto 8)    <= X"20";  -- " "
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif mode_select = "01" then
			
				status1 <= X"4f";
				status2 <= X"4e";
				status3 <= X"20";
				
				status4 <= X"4f";
				status5 <= X"46";
				status6 <= X"46";
				
				line1(127 downto 120) <= X"43";  -- C
				line1(119 downto 112) <= X"48";  -- H
				line1(111 downto 104) <= X"31";  -- 1
				line1(103 downto 96)  <= X"3a";  -- :
				line1(95 downto 88)   <= status1;  -- O
				line1(87 downto 80)   <= status2;  -- N or F
				line1(79 downto 72)   <= status3;  -- " " or F
				line1(71 downto 64)   <= X"20";  -- " "
				line1(63 downto 56)   <= X"43";  -- C
				line1(55 downto 48)   <= X"48";  -- H
				line1(47 downto 40)   <= X"32";  -- 2
				line1(39 downto 32)   <= X"3a";  -- :
				line1(31 downto 24)   <= status4;  -- O
				line1(23 downto 16)   <= status5;  -- N or F
				line1(15 downto 8)    <= status6;  -- " " or F
				line1(7 downto 0)     <= X"20";  -- " "	
			
				line2(127 downto 120) <= X"43";  -- C
				line2(119 downto 112) <= X"48";  -- H
				line2(111 downto 104) <= X"31";  -- 1
				line2(103 downto 96)  <= X"3a";  -- :
				line2(95 downto 88)   <= f;  -- " "
				line2(87 downto 80)   <= X"2e";  -- .
				line2(79 downto 72)   <= s;  -- " "
				line2(71 downto 64)   <= t;  -- " "
				line2(63 downto 56)   <= X"43";  -- C
				line2(55 downto 48)   <= X"48";  -- H
				line2(47 downto 40)   <= X"32";  -- 2
				line2(39 downto 32)   <= X"3a";  -- :
				line2(31 downto 24)   <= X"20";  -- " "
				line2(23 downto 16)   <= X"2e";  -- .
				line2(15 downto 8)    <= X"20";  -- " "
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif mode_select = "10" then
			
				status1 <= X"4f";
				status2 <= X"46";
				status3 <= X"46";
				
				status4 <= X"4f";
				status5 <= X"4e";
				status6 <= X"20";
				
				line1(127 downto 120) <= X"43";  -- C
				line1(119 downto 112) <= X"48";  -- H
				line1(111 downto 104) <= X"31";  -- 1
				line1(103 downto 96)  <= X"3a";  -- :
				line1(95 downto 88)   <= status1;  -- O
				line1(87 downto 80)   <= status2;  -- N or F
				line1(79 downto 72)   <= status3;  -- " " or F
				line1(71 downto 64)   <= X"20";  -- " "
				line1(63 downto 56)   <= X"43";  -- C
				line1(55 downto 48)   <= X"48";  -- H
				line1(47 downto 40)   <= X"32";  -- 2
				line1(39 downto 32)   <= X"3a";  -- :
				line1(31 downto 24)   <= status4;  -- O
				line1(23 downto 16)   <= status5;  -- N or F
				line1(15 downto 8)    <= status6;  -- " " or F
				line1(7 downto 0)     <= X"20";  -- " "	
			
				line2(127 downto 120) <= X"43";  -- C
				line2(119 downto 112) <= X"48";  -- H
				line2(111 downto 104) <= X"31";  -- 1
				line2(103 downto 96)  <= X"3a";  -- :
				line2(95 downto 88)   <= X"20";  -- " "
				line2(87 downto 80)   <= X"2e";  -- .
				line2(79 downto 72)   <= X"20";  -- " "
				line2(71 downto 64)   <= X"20";  -- " "
				line2(63 downto 56)   <= X"43";  -- C
				line2(55 downto 48)   <= X"48";  -- H
				line2(47 downto 40)   <= X"32";  -- 2
				line2(39 downto 32)   <= X"3a";  -- :
				line2(31 downto 24)   <= f;  -- " "
				line2(23 downto 16)   <= X"2e";  -- .
				line2(15 downto 8)    <= s;  -- " "
				line2(7 downto 0)     <= t;  -- " "
				
			elsif mode_select = "11" then
			
				status1 <= X"4f";
				status2 <= X"4e";
				status3 <= X"20";
				
				status4 <= X"4f";
				status5 <= X"4e";
				status6 <= X"20";
				
				line1(127 downto 120) <= X"43";  -- C
				line1(119 downto 112) <= X"48";  -- H
				line1(111 downto 104) <= X"31";  -- 1
				line1(103 downto 96)  <= X"3a";  -- :
				line1(95 downto 88)   <= status1;  -- O
				line1(87 downto 80)   <= status2;  -- N or F
				line1(79 downto 72)   <= status3;  -- " " or F
				line1(71 downto 64)   <= X"20";  -- " "
				line1(63 downto 56)   <= X"43";  -- C
				line1(55 downto 48)   <= X"48";  -- H
				line1(47 downto 40)   <= X"32";  -- 2
				line1(39 downto 32)   <= X"3a";  -- :
				line1(31 downto 24)   <= status4;  -- O
				line1(23 downto 16)   <= status5;  -- N or F
				line1(15 downto 8)    <= status6;  -- " " or F
				line1(7 downto 0)     <= X"20";  -- " "	
			
				line2(127 downto 120) <= X"43";  -- C
				line2(119 downto 112) <= X"48";  -- H
				line2(111 downto 104) <= X"31";  -- 1
				line2(103 downto 96)  <= X"3a";  -- :
				line2(95 downto 88)   <= X"20";  -- " "
				line2(87 downto 80)   <= X"2e";  -- .
				line2(79 downto 72)   <= X"20";  -- " "
				line2(71 downto 64)   <= X"20";  -- " "
				line2(63 downto 56)   <= X"43";  -- C
				line2(55 downto 48)   <= X"48";  -- H
				line2(47 downto 40)   <= X"32";  -- 2
				line2(39 downto 32)   <= X"3a";  -- :
				line2(31 downto 24)   <= X"20";  -- " "
				line2(23 downto 16)   <= X"2e";  -- .
				line2(15 downto 8)    <= X"20";  -- " "
				line2(7 downto 0)     <= X"20";  -- " "
				
			end if;
				
      else
         timer <= timer - 1;
      
		end if;
	end if;     		
 end process;
  
   line1_buffer <= line1; --when switch_lines = '1' else line1;
   line2_buffer <= line2; --when switch_lines = '1' else line2;
	
end architecture behavior;