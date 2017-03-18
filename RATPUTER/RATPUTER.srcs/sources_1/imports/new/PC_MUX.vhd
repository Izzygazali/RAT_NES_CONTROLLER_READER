----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2017 09:53:14 AM
-- Design Name: 
-- Module Name: pcSelectionMUX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_MUX is Port( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
                               FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
                               PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
                               TO_PC_DIN : out STD_LOGIC_VECTOR (9 downto 0));
end PC_MUX;

architecture Behavioral of PC_MUX is

begin
    process (PC_MUX_SEL, FROM_IMMED, FROM_STACK) 
    begin
        case (PC_MUX_SEL) is
            when "00" => TO_PC_DIN <= FROM_IMMED;
            when "01" => TO_PC_DIN <= FROM_STACK;
            when "10" => TO_PC_DIN <= "1111111111";
            when others => TO_PC_DIN <= (others => '0');
        end case;
    end process;

end Behavioral;
