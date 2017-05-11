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
    clk, sleep    : in  std_logic;
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
		
		line1(127 downto 120) <= X"4f";  -- O
		line1(119 downto 112) <= X"73";  -- s
		line1(111 downto 104) <= X"63";  -- c
		line1(103 downto 96)  <= X"69";  -- i
		line1(95 downto 88)   <= X"6c";  -- l
		line1(87 downto 80)   <= X"6c";  -- l
		line1(79 downto 72)   <= X"6f";  -- o
		line1(71 downto 64)   <= X"73";  -- s
		line1(63 downto 56)   <= X"63";  -- c
		line1(55 downto 48)   <= X"6f";  -- o
		line1(47 downto 40)   <= X"70";  -- p
		line1(39 downto 32)   <= X"65";  -- e
		line1(31 downto 24)   <= X"20";  -- " "
		line1(23 downto 16)   <= X"32";  -- 2
		line1(15 downto 8)    <= X"43";  -- C
		line1(7 downto 0)     <= X"48";  -- H
		
   rst <= '0';

  -- switch lines every second
  process(clk)
  begin
    if rising_edge(clk) then
	
      if timer = 0 then
			timer <= 25000000;
			
			if sleep = '1' then
			
				line2(127 downto 120) <= X"20";  -- " "
				line2(119 downto 112) <= X"20";  -- " "
				line2(111 downto 104) <= X"20";  -- " "
				line2(103 downto 96)  <= X"4d";  -- M
				line2(95 downto 88)   <= X"6f";  -- o
				line2(87 downto 80)   <= X"64";  -- d
				line2(79 downto 72)   <= X"65";  -- e
				line2(71 downto 64)   <= X"3a";  -- :
				line2(63 downto 56)   <= X"53";  -- S
				line2(55 downto 48)   <= X"6c";  -- l
				line2(47 downto 40)   <= X"65";  -- e
				line2(39 downto 32)   <= X"65";  -- e
				line2(31 downto 24)   <= X"70";  -- p
				line2(23 downto 16)   <= X"20";  -- " "
				line2(15 downto 8)    <= X"20";  -- " "
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif sleep = '0' then
			
			if mode_select = "00" then
			
				line2(127 downto 120) <= X"20";  -- " "
				line2(119 downto 112) <= X"20";  -- " "
				line2(111 downto 104) <= X"20";  -- " "
				line2(103 downto 96)  <= X"20";  -- " "
				line2(95 downto 88)   <= X"4d";  -- M
				line2(87 downto 80)   <= X"6f";  -- o
				line2(79 downto 72)   <= X"64";  -- d
				line2(71 downto 64)   <= X"65";  -- e
				line2(63 downto 56)   <= X"3a";  -- :
				line2(55 downto 48)   <= X"4f";  -- O
				line2(47 downto 40)   <= X"66";  -- f
				line2(39 downto 32)   <= X"66";  -- f
				line2(31 downto 24)   <= X"20";  -- " "
				line2(23 downto 16)   <= X"20";  -- " "
				line2(15 downto 8)    <= X"20";  -- " "
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif mode_select = "01" then	
			
				line2(127 downto 120) <= X"20";  -- " "
				line2(119 downto 112) <= X"4d";  -- M
				line2(111 downto 104) <= X"6f";  -- o
				line2(103 downto 96)  <= X"64";  -- d
				line2(95 downto 88)   <= X"65";  -- e
				line2(87 downto 80)   <= X"3a";  -- :
				line2(79 downto 72)   <= X"53";  -- S
				line2(71 downto 64)   <= X"69";  -- i
				line2(63 downto 56)   <= X"6e";  -- n
				line2(55 downto 48)   <= X"67";  -- g
				line2(47 downto 40)   <= X"6c";  -- g
				line2(39 downto 32)   <= X"65";  -- e
				line2(31 downto 24)   <= X"43";  -- C
				line2(23 downto 16)   <= X"48";  -- H
				line2(15 downto 8)    <= X"31";  -- 1
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif mode_select = "10" then
			
				line2(127 downto 120) <= X"20";  -- " "
				line2(119 downto 112) <= X"4d";  -- M
				line2(111 downto 104) <= X"6f";  -- o
				line2(103 downto 96)  <= X"64";  -- d
				line2(95 downto 88)   <= X"65";  -- e
				line2(87 downto 80)   <= X"3a";  -- :
				line2(79 downto 72)   <= X"53";  -- S
				line2(71 downto 64)   <= X"69";  -- i
				line2(63 downto 56)   <= X"6e";  -- n
				line2(55 downto 48)   <= X"67";  -- g
				line2(47 downto 40)   <= X"6c";  -- g
				line2(39 downto 32)   <= X"65";  -- e
				line2(31 downto 24)   <= X"43";  -- C
				line2(23 downto 16)   <= X"48";  -- H
				line2(15 downto 8)    <= X"32";  -- 2
				line2(7 downto 0)     <= X"20";  -- " "
				
			elsif mode_select = "11" then
			
				line2(127 downto 120) <= X"4d";  -- C
				line2(119 downto 112) <= X"6f";  -- H
				line2(111 downto 104) <= X"64";  -- 1
				line2(103 downto 96)  <= X"65";  -- :
				line2(95 downto 88)   <= X"3a";  -- " "
				line2(87 downto 80)   <= X"44";  -- .
				line2(79 downto 72)   <= X"75";  -- " "
				line2(71 downto 64)   <= X"61";  -- " "
				line2(63 downto 56)   <= X"6c";  -- C
				line2(55 downto 48)   <= X"43";  -- H
				line2(47 downto 40)   <= X"68";  -- 2
				line2(39 downto 32)   <= X"61";  -- :
				line2(31 downto 24)   <= X"6e";  -- " "
				line2(23 downto 16)   <= X"6e";  -- .
				line2(15 downto 8)    <= X"65";  -- " "
				line2(7 downto 0)     <= X"6c";  -- " "
				
			end if;
			
			end if;
			
      else
         timer <= timer - 1;
      
		end if;
	end if;     		
 end process;
  
   line1_buffer <= line1; --when switch_lines = '1' else line1;
   line2_buffer <= line2; --when switch_lines = '1' else line2;
	
end architecture behavior;