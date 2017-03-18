----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2017 02:37:13 PM
-- Design Name: 
-- Module Name: sim - Behavioral
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

entity sim is
--  Port ( );
end sim;

architecture Behavioral of sim is
component RAT_wrapper Port (  LEDS              : out STD_LOGIC_VECTOR (7 downto 0);
          SWITCHES          : in  STD_LOGIC_VECTOR (7 downto 0);
          SEVEN_SEG_CATHODE : out STD_LOGIC_VECTOR (7 downto 0);
          SEVEN_SEG_ANODE   : out STD_LOGIC_VECTOR(3 downto 0);
          UART_TX           : out STD_LOGIC;
          INT               : in STD_LOGIC;
          RST               : in  STD_LOGIC;
          CLK               : in  STD_LOGIC;
           R_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
          G_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
          B_OUT      : out STD_LOGIC_VECTOR (3 downto 0);
          HSYNC      : out STD_LOGIC;
          VSYNC      : out STD_LOGIC);
end component;
signal SWITCHES, LEDS : STD_LOGIC_VECTOR(7 downto 0);
signal RST, CLK, INT, HSYNC, VSYNC : STD_LOGIC;
signal R_OUT, G_OUT : STD_LOGIC_VECTOR (3 downto 0);
signal B_OUT : STD_LOGIC_VECTOR (3 downto 0);

begin
UTT : RAT_wrapper port map(R_OUT => R_OUT, G_OUT => G_OUT, B_OUT => B_OUT, CLK => CLK, RST => RST, SWITCHES => SWITCHES, LEDS => LEDS, INT => INT, HSYNC => HSYNC, VSYNC => VSYNC);
process begin
    CLK <= '0';
    SWITCHES <= "00000001";
    wait for 10 ns;
    for i in 0 to 100000000 loop
        CLK <= not CLK;
        wait for 10 ns;
    end loop;
    wait;
end process;
end Behavioral;
