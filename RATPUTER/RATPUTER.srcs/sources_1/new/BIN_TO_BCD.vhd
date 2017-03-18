----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Description: This module takes a binary input and converts to a binary coded
--              decimal number. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity binToBCD is port ( number   : in  std_logic_vector (9 downto 0);
                          hundreds : out std_logic_vector (3 downto 0);
                          tens     : out std_logic_vector (3 downto 0);
                          ones     : out std_logic_vector (3 downto 0));
end binToBCD;

architecture Behavioral of binToBCD is

    begin
        bin_to_bcd : process (number)
        -- Internal variable for storing bits
        variable shift : unsigned(21 downto 0);
        
        -- Alias for parts of shift register
        alias num is shift(9 downto 0);
        alias one is shift(13 downto 10);
        alias ten is shift(17 downto 14);
        alias hun is shift(21 downto 18);
        
        begin
            -- Clear previous number and store new number in shift register
            num := unsigned(number);
            one := X"0";
            ten := X"0";
            hun := X"0";
            
            -- Loop eight times
            for i in 1 to num'Length loop
                -- Check if any digit is greater than or equal to 5
                if one >= 5 then
                    one := one + 3;
                end if;
            
                if ten >= 5 then
                    ten := ten + 3;
                end if;
            
                if hun >= 5 then
                    hun := hun + 3;
                end if;
            
                -- Shift entire register left once
                shift := shift_left(shift, 1);
            end loop;
            
            -- Push decimal numbers to output
            hundreds <= std_logic_vector(hun);
            tens     <= std_logic_vector(ten);
            ones     <= std_logic_vector(one);
        end process;
end Behavioral;