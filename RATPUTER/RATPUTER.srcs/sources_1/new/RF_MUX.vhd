----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/08/2017 11:55:01 AM
-- Description: This MUX is used to determine which input is sent to the register
--              file. The Select is determine by the Control Unit.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RF_MUX is port (ALU_RESULT   : in STD_LOGIC_VECTOR (7 downto 0);  -- From ALU           "00"
                       SCRATCH      : in STD_LOGIC_VECTOR (7 downto 0);  -- From Scratch RAM   "01"
                       STACK_PTR    : in STD_LOGIC_VECTOR (7 downto 0);  -- From stack pointer "10"
                       IN_PORT      : in STD_LOGIC_VECTOR (7 downto 0);  -- From input port    "11"
                       RF_WR_SEL    : in STD_LOGIC_VECTOR(1 downto 0);
                       TO_DIN       : out STD_LOGIC_VECTOR (7 downto 0));
end RF_MUX;

architecture Behavioral of RF_MUX is
    begin
        process (RF_WR_SEL, IN_PORT, STACK_PTR, SCRATCH, ALU_RESULT) 
        begin
            case (RF_WR_SEL) is
                when "00" => TO_DIN <= ALU_RESULT;
                when "01" => TO_DIN <= SCRATCH;
                when "10" => TO_DIN <= STACK_PTR;
                when "11" => TO_DIN <= IN_PORT;
                when others => TO_DIN <= ALU_RESULT;
            end case;
    end process;
end Behavioral;
