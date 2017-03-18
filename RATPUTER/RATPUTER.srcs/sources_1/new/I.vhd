----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/08/2017 08:50:29 PM
-- Project Name: INTERUPTS 
-- Description: This VHDL module handles the RAT MCU's interupt routine.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I is port ( I_SET : in STD_LOGIC;
                   I_CLR : in STD_LOGIC;
                   CLK   : in STD_LOGIC;
                   I_OUT : out STD_LOGIC);
end I;

architecture Behavioral of I is
    begin
        --The interrupts are set/cleared on the rising clock edge.
        process (CLK) begin
            if (RISING_EDGE(CLK))then
                if (I_SET = '1') then
                    I_OUT <= '1';
                elsif (I_CLR = '1') then
                    I_OUT <= '0';
                end if;
            end if;
        end process;
end Behavioral;
