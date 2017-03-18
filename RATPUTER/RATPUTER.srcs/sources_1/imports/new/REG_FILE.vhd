------------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 01/26/2017 06:43:40 PM
-- Description: The Register File is a 32x8 dual-port RAM. The Register File can read 2 operands (X and Y) 
--              and writes to 1 memory address (X).
------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG_FILE is port (  ADDX, ADDY : in STD_LOGIC_VECTOR (4 downto 0);   -- memory location X and Y
                           DIN        : in STD_LOGIC_VECTOR (7 downto 0);   -- data to store in memory location X
                           WR, CLK    : in STD_LOGIC ;                      -- Clk signal and Write Enable
                           DX_OUT     : out STD_LOGIC_VECTOR (7 downto 0);  -- Output data in memory location X
                           DY_OUT     : out STD_LOGIC_VECTOR (7 downto 0)); -- Output data in memory location Y
end REG_FILE;


architecture Behavioral of REG_FILE is
    
    -- Define 32x8 register type and intialize locations to 0x00
    Type regFileMem is array(0 to 31) of STD_LOGIC_VECTOR(7 downto 0);
    signal regFile : regFileMem := (others => "00000000"); 
        
        begin
            -- Read and output X and Y asynchronously
            DX_OUT <= regFile(to_integer(unsigned(ADDX)));
            DY_OUT <= regFile(to_integer(unsigned(ADDY)));
            
            -- Write to X synchronously
            process (CLK) begin
                if (rising_edge(CLK)) then
                    if (WR = '1') then
                        regFile(to_integer(unsigned(ADDX))) <= Din;
                    end if;
                end if;
            end process;
            
end Behavioral;
