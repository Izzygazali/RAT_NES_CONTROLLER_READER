----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Description: This module behaves as the driver for the seven segment display on
--              the basys 3 board. The driver takes a HEX input, converts it to 
--              BCD and then outputs it to the display by turing on/off certain
--              anodes and cathodes. For a detailed explanation of how the seven 
--              segment display works, please refer to the basys 3 board manual on
--              digilent.com
-----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SEVEN_SEG_DRIVER is port ( HEX_INPUT : in STD_LOGIC_VECTOR (7 downto 0);
                                  CLK       : in STD_LOGIC;
                                  RST       : in STD_LOGIC;
                                  ANODE     : out STD_LOGIC_VECTOR (3 downto 0);
                                  CATHODE   : out STD_LOGIC_VECTOR (7 downto 0));
end SEVEN_SEG_DRIVER;

architecture Behavioral of SEVEN_SEG_DRIVER is

---- Define components ------------------------------------------------------------
    component binToBCD port ( number   : in  std_logic_vector (9 downto 0);
                              hundreds : out std_logic_vector (3 downto 0);
                              tens     : out std_logic_vector (3 downto 0);
                              ones     : out std_logic_vector (3 downto 0));
    end component;
    
    
---- Define signals ----------------------------------------------------------------
    signal s_INPUT                                  : STD_LOGIC_VECTOR(9 downto 0);
    signal s_DIGIT_VAL, s_HUNDREDS, s_TENS, s_ONES  :  STD_LOGIC_VECTOR(3 downto 0);
    signal s_SLOW_CLOCK                             : STD_LOGIC := '0';
    
    begin
--- Convert hex input to into a BCD number--------------------------------------------------------   

    s_INPUT <= "00"&HEX_INPUT;
    
    BIN_TO_BCD: binToBCD
    port map(number => s_INPUT, hundreds => s_HUNDREDS, TENS => s_TENS, ones => s_ONES); 
 
 
---------------------------------------------------------------------------------------      
---- Clock divider to slow down the basys boards 100 MHz clock down to 240 Hz so that it
---- is viewable on the display.   
    CLOCK_DIV : process (CLK, RST)
        variable count : std_logic_vector(29 downto 0) := (others => '0');
    begin
        if (RST = '1') then 
            s_SLOW_CLOCK <= '0';
            count := (others => '0');    
        else
            if (rising_edge(CLK)) then
                if (count >= (std_logic_vector(to_unsigned(208333, 29)))) then
                    s_SLOW_CLOCK  <= NOT(s_SLOW_CLOCK);
                    count := (others => '0');
                else
                    count := count + 1;
                end if;
            end if;
        end if;
    end process CLOCK_DIV; 
 ----------------------------------------------------------------------------------------   
    
--- This process block updates the anodes every 60 Hz to to make the four digit places on 
--- the seven segment display different numbers at the same time.    
    DIGIT_SHIFT : process (s_SLOW_CLOCK)
        variable DIG_CNT : std_logic_vector(3 downto 0) := "0000";
        variable v_DIGIT_VAL : std_logic_vector(3 downto 0) := "0000";
    begin
        if (rising_edge(s_SLOW_CLOCK)) then
            if (DIG_CNT = "0000") then
                v_DIGIT_VAL := s_ONES;
                ANODE <= "0111";
                DIG_CNT := DIG_CNT + "0001";
            elsif (DIG_CNT = "0001") then
                v_DIGIT_VAL := s_TENS;
                if (v_DIGIT_VAL = "0000" and s_HUNDREDS = "0000") then
                    ANODE <= "1111";
                else
                    ANODE <= "1011";
                end if;
                DIG_CNT := DIG_CNT + "0001";
            elsif (DIG_CNT = "0010") then
                v_DIGIT_VAL := s_HUNDREDS;
                if (v_DIGIT_VAL = "0000") then
                    ANODE <= "1111";
                else
                    ANODE <= "1101";
                end if;
                DIG_CNT := "0000";
            end if;
            s_DIGIT_VAL <= v_DIGIT_VAL;
        end if;
    end process;
--------------------------------------------------------------------------
    
--- This process block turns on the correct cathodes to resemble the digit that
--- we want to display on the seven segment dispay.   
    DECODE: process (s_DIGIT_VAL) is begin
        case (s_DIGIT_VAL) is 
            when "0000" => CATHODE <= not "00111111";
            when "0001" => CATHODE <= not "00000110";
            when "0010" => CATHODE <= not "01011011";
            when "0011" => CATHODE <= not "01001111";
            when "0100" => CATHODE <= not "01100110";
            when "0101" => CATHODE <= not "01101101";
            when "0110" => CATHODE <= not "01111101";
            when "0111" => CATHODE <= not "00000111";
            when "1000" => CATHODE <= not "01111111";
            when "1001" => CATHODE <= not "01100111";
            when "1010" => CATHODE <= not "01110111";
            when "1011" => CATHODE <= not "01111100";
            when "1100" => CATHODE <= not "00111001";
            when "1101" => CATHODE <= not "01011110";
            when "1110" => CATHODE <= not "01111001";
            when "1111" => CATHODE <= not "01110001";
            when others =>  CATHODE <= not "00000000";
        end case;
     end process;

end Behavioral;
