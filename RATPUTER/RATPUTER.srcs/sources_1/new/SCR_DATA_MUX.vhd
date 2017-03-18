-----------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/21/2017 08:46:44 AM
-- Description: This MUX is used to determine where the data going into the SRAM 
--              comes from.
-----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SCR_DATA_MUX is port (  SCR_DATA_SEL   : in STD_LOGIC;                       -- Select determined by Control Unit
                               DATA_FROM_DX   : in STD_LOGIC_VECTOR (7 downto 0);   -- '0' data from X output of Register File
                               DATA_FROM_PC   : in STD_LOGIC_VECTOR (9 downto 0);   -- '1' data from Program Counter
                               TO_DATA_IN_SCR : out STD_LOGIC_VECTOR (9 downto 0)); -- input to SRAM
end SCR_DATA_MUX;

architecture Behavioral of SCR_DATA_MUX is
    begin
        process(DATA_FROM_PC, DATA_FROM_DX, SCR_DATA_SEL)
            begin
                case (SCR_DATA_SEL) is
                    -- The X output of the Register File is only 8 bits therefore we need
                    -- to add 2 leading bits in order to store it in the SRAM's 10 bit wide
                    -- memory addresses.
                    when '0' => TO_DATA_IN_SCR <= "00" & DATA_FROM_DX;
                    when '1' => TO_DATA_IN_SCR <= DATA_FROM_PC;
                when others => TO_DATA_IN_SCR <= "00" & DATA_FROM_DX;
            end case;
        end process;
end Behavioral;
