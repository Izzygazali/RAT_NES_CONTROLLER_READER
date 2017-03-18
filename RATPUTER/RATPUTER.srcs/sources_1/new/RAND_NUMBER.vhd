-------------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Description: This module is used to generate random bits for the colors to be displayed on the VGA
--              display. The colors are represented in this sequence, RRR-GGG-BB
-------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pseudo_random is port ( CLK             : in std_logic;
                               PSUEDO_RAND_NUM : out std_logic_vector (7 downto 0));          
end pseudo_random;

architecture Behavioral of pseudo_random is

    begin
        process(CLK)
            variable rand_temp  : std_logic_vector(7 downto 0)  := (7 => '1',others => '0');
            variable temp_cnt   : unsigned(2 downto 0)          := (others => '0');  
            variable temp       : std_logic                     := '0';
        begin
            if(rising_edge(CLK)) then
                
                -- Generate random bits and store them in rand_temp
                temp := rand_temp(7) xor rand_temp(6);
                rand_temp(7 downto 1) := rand_temp(4 downto 2) & rand_temp(1 downto 0) & rand_temp(6 downto 5);
                rand_temp(0) := temp;
                
                -- count the number bits that are high in rand temp
                temp_cnt := temp_cnt + ("00" & rand_temp(0));
                temp_cnt := temp_cnt + ("00" & rand_temp(1));
                temp_cnt := temp_cnt + ("00" & rand_temp(2));
                temp_cnt := temp_cnt + ("00" & rand_temp(3));
                temp_cnt := temp_cnt + ("00" & rand_temp(4));
                temp_cnt := temp_cnt + ("00" & rand_temp(5));
                temp_cnt := temp_cnt + ("00" & rand_temp(6));
                temp_cnt := temp_cnt + ("00" & rand_temp(7));
                
                -- only set the output to rand_temp if the number of bits that are high is greater than three
                -- this is done to limit the dark colors from being output to the screen. The possibility of a
                -- dark color is still possible however black will never be set as the color and it is rare that
                -- a really dark color will be set.
                if (temp_cnt > "011") then
                    PSUEDO_RAND_NUM <= rand_temp;
                end if;
                  
            end if;
        end process;
end;