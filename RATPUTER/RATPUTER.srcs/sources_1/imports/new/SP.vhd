----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/21/2017 08:57:52 AM
-- Project Name: StackPointer 
-- Description: A VHDL module for the RAT MCU's stack pointer. The Stack Pointer 
--              is an up/down counter that can be asynchronously reset and can be 
--              loaded with a value.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SP is port ( RST         : in STD_LOGIC;                         -- Reset
                    SP_LD       : in STD_LOGIC;                         -- Load
                    SP_INCR     : in STD_LOGIC;                         -- Increment
                    SP_DECR     : in STD_LOGIC;                         -- Decrement
                    A_DATA_IN   : in STD_LOGIC_VECTOR (7 downto 0);     -- Input data when loading
                    CLK         : in STD_LOGIC;                         -- Clock signal
                    DATA_OUT    : out STD_LOGIC_VECTOR (7 downto 0));   -- Stack pointer output 
                    
end SP;
    architecture Behavioral of SP is

    begin
        counter: process (CLK, RST)
            variable count : unsigned(7 downto 0) := (others => '0');  
        begin
        -- Asynchronous Reset
            if (RST = '1') then             
                count := (others => '0');
            end if; 
            
        -- Synchronoys Increment, Decrement and Load
            if (rising_edge(CLK)) then                     
                if (SP_LD = '1') then
                    count := unsigned(A_DATA_IN);
                elsif (SP_INCR = '1') then
                    count := count + 1;     
                elsif (SP_DECR = '1') then
                    count := count - 1;         
                end if;
            end if;
        DATA_OUT <= STD_LOGIC_VECTOR(count);
        end process;
end Behavioral;
