----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 01/26/2017 06:43:30 PM
-- Project Name: ScratchRam
-- Description: A VHDL module for the Scratch RAM on the RAT MCU. The SRAM is 
--              256 locations deep by 10 bits wide.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SCR is port (SCR_ADDR : in STD_LOGIC_VECTOR (7 downto 0);         -- Address/location in SRAM
                    SCR_WE : in STD_LOGIC;                               -- Write enable
                    SCR_DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);      -- Input data
                    CLK : in STD_LOGIC;                                  -- Clock signal 
                    SCR_DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));   -- Output data
end SCR;

architecture Behavioral of SCR is
    -- Define 256x10 memory locations and intialize them to 0
    type memory is array(0 to 255) of std_logic_vector(9 downto 0);
    signal s_SRAM : memory := (others => "0000000000");

    begin
        -- MCU reads SRAM asynchronously
        SCR_DATA_OUT <= s_SRAM(to_integer(unsigned(SCR_ADDR)));
        
        -- MCU writes to SRAM synchronously
        process (CLK) 
        begin
            if (rising_edge(CLK)) then
                if (SCR_WE = '1') then
                    s_SRAM(to_integer(unsigned(SCR_ADDR))) <= SCR_DATA_IN;
                end if;
            end if;
        end process;

end Behavioral;
