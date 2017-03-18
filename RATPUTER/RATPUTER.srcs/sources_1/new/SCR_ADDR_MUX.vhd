----------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/21/2017 08:46:44 AM: 
-- Description: This MUX is used to determine which input is sent to the address operand of 
--              the Scrath RAM
----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SCR_ADDR_MUX is port (SCR_ADDR_SEL           : in STD_LOGIC_VECTOR (1 downto 0); -- Select from control unit
                             ADDR_FROM_DY           : in STD_LOGIC_VECTOR (7 downto 0); -- "00" from register file y output
                             ADDR_FROM_IR           : in STD_LOGIC_VECTOR (7 downto 0); -- "01" form instruction register
                             ADDR_FROM_SP           : in STD_LOGIC_VECTOR (7 downto 0); -- "10" from stack pointer output
                             ADDR_FROM_SP_MINUS_ONE : in STD_LOGIC_VECTOR (7 downto 0); -- "11" from stack pionter output - 1
                             TO_ADDR_SCR            : out STD_LOGIC_VECTOR (7 downto 0));
end SCR_ADDR_MUX;

architecture Behavioral of SCR_ADDR_MUX is

begin
    process (SCR_ADDR_SEL, ADDR_FROM_DY, ADDR_FROM_IR, ADDR_FROM_SP, ADDR_FROM_SP_MINUS_ONE) 
        begin
            case (SCR_ADDR_SEL) is
                when "00" => TO_ADDR_SCR <= ADDR_FROM_DY;
                when "01" => TO_ADDR_SCR <= ADDR_FROM_IR;
                when "10" => TO_ADDR_SCR <= ADDR_FROM_SP;
            --- This address is chosen when writing to the stack. The stack pointer points to the current
            --- location in the stack so this address writes to 1 less than where the pointer is currently at.
                when "11" => TO_ADDR_SCR <= std_logic_vector(unsigned(ADDR_FROM_SP_MINUS_ONE) - "00000001");
            when others => TO_ADDR_SCR <= (others => '0');
        end case;
    end process;
end Behavioral;
