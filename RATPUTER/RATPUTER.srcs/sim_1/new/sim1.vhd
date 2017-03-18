----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/08/2017 01:22:05 PM
-- Design Name: 
-- Module Name: sim1 - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sim1 is


end sim1;

architecture Behavioral of sim1 is

component RAT_WRAPPER is Port ( LEDS     : out   STD_LOGIC_VECTOR (7 downto 0);
                                SWITCHES : in    STD_LOGIC_VECTOR (7 downto 0);
                                RST      : in    STD_LOGIC;
                                CLK      : in    STD_LOGIC);
end component;

signal RST, CLK : STD_LOGIC;
signal LEDS, SWITCHES : STD_LOGIC_VECTOR(7 downto 0);

begin

    UUT : RAT_WRAPPER port map(RST  => RST, CLK => CLK, SWITCHES => SWITCHES, LEDS => LEDS);
    
    process begin
        SWITCHES <= "11111111";
        wait for 250 ns;
        SWITCHES <= "00000000";
        wait for 250 ns;
        SWITCHES <= "01000110";
        wait for 250 ns;
           
                
        wait;
    end process;
    
    process begin
        CLK <= '0';
        wait for 5 ns;
        for i in 0 to 600 loop
            CLK <= not CLK;
            wait for 5 ns;
        end loop;
        wait;
    end process;

end Behavioral;
