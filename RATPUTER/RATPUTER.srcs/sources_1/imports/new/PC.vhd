----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 01/11/2017 09:32:22 AM
-- Project Name: Experiment 3 - Program Counter
-- Description: A VHDL module for a program counter. The PC can count from 0 or 
--              a specific value loaded into the Din input. 
--------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is Port( Din : in STD_LOGIC_VECTOR (9 downto 0);        --input Data
                   PC_LD : in STD_LOGIC;                          --Load PC when high
                   PC_INC : in STD_LOGIC;                         --Increment PC when high
                   RST : in STD_LOGIC;                            --Reset PC when high
                   CLK : in STD_LOGIC;                            --All input are clock driven (synchronous)
                   PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0)); 
end PC;

architecture Behavioral of PC is
    begin
-------- Synchronous counter that can be incremented, reset and loaded with a given value.---------------------
        counter: process (CLK)
            variable count : unsigned(9 downto 0) := (others => '0');  
        begin
            if (rising_edge(CLK)) then                  
                if (RST = '1') then             
                    count := (others => '0');
                elsif (PC_LD = '1') then
                    count := unsigned(Din);
                elsif (PC_INC = '1') then
                    count := count + 1;              
                end if;
                
                PC_COUNT <= STD_LOGIC_VECTOR(count);
            end if;      
        end process counter;
end Behavioral;
