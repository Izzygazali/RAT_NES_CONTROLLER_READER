---------------------------------------------------------------------------------- 
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 11/27/2016 11:44:56 PM
-- Project Name: 4 digit BCD display.
-- Description: A part that connects the display driver to the decoder.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity driverAndDecoder is
	Port ( number : in STD_LOGIC_VECTOR (15 downto 0);
       	enableOut : out STD_LOGIC_VECTOR(3 downto 0);
       	datOut : out STD_LOGIC_VECTOR(7 downto 0);
       	clk : in STD_LOGIC);
end driverAndDecoder;

architecture Behavioral of driverAndDecoder is

component bintohex port (I : in STD_LOGIC_VECTOR(3 downto 0);
                     	P : out STD_LOGIC_VECTOR(7 downto 0));
end component;

component fourDigitDriver Port ( number : in STD_LOGIC_VECTOR (15 downto 0);
                              	sel : out STD_LOGIC_VECTOR (3 downto 0);
                              	digit : out STD_LOGIC_VECTOR (3 downto 0);
                              	RST, inClk : in STD_LOGIC);
end component;

signal sDigit : STD_LOGIC_VECTOR(3 downto 0);

begin
	driver : fourDigitDriver port map(number => number, sel => enableOut, digit => sDigit, inClk => clk, RST => '0');
	decoder : bintohex port map(I => sDigit, P => datOut);
end Behavioral;