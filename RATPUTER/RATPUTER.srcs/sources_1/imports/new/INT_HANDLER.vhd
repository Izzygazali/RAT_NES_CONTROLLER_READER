----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 03/01/2017 09:06:09 PM
-- Description: The Interrupt Handler produces a pulse on the RAT MCU's interrupt 
--              signal whenever the time changes from one value to another. By 
--              making the timer interrupt driven we can avoid constantly polling
--              the time.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INT_HANDLER is port( TIMER_INPUT : in STD_LOGIC_VECTOR (7 downto 0);
                            CLK         : in STD_LOGIC;
                            INT_OUT     : out STD_LOGIC);
end INT_HANDLER;

architecture Behavioral of INT_HANDLER is
    begin
        INT: process(CLK) 
            variable s_COUNT : unsigned(3 downto 0) := (others => '0');
            variable s_PREV_INPUT : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
        begin
            if (rising_edge(CLK)) then
                if (TIMER_INPUT /= s_PREV_INPUT) then
                    INT_OUT <= '1';
                    
                    -- This if statement holds the interrupt signal for a while after
                    -- its triggered to ensure that remains asserted long enough for 
                    -- the MCU to see it.
                    if (s_COUNT = "1111") then
                        INT_OUT <= '0';
                        s_COUNT := "0000";
                        s_PREV_INPUT := TIMER_INPUT;
                    end if;
                    
                    s_COUNT := s_COUNT + "0001";
                end if;
            end if;
        end process;
end Behavioral;
