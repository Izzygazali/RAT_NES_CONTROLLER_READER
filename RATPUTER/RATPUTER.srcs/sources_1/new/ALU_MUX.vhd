----------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali
-- Create Date: 02/08/2017 12:00:36 PM
-- Description: This MUX is used to determine if the input to second operand of the 
--              ALU (B) is from a value stored in a register (Register File) or from
--              an immediate value from the Instruction Register (7:0)
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_MUX is port ( FROM_REG       : in STD_LOGIC_VECTOR (7 downto 0);     -- '0' From Register File
                         FROM_IMMED     : in STD_LOGIC_VECTOR (7 downto 0);     -- '1' From Instruction Register
                         ALU_OPY_SEL    : in STD_LOGIC;                         -- Select from Control Unit
                         TO_B           : out STD_LOGIC_VECTOR (7 downto 0));   -- Output to B
end ALU_MUX;

architecture Behavioral of ALU_MUX is
    begin
        process(ALU_OPY_SEL, FROM_REG, FROM_IMMED)
        begin
            case (ALU_OPY_SEL) is
                when '0' => TO_B <= FROM_REG;
                when '1' => TO_B <= FROM_IMMED;
                when others => TO_B <= FROM_REG;
            end case;
        end process;
end Behavioral;
