library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity bintohex is
	Port (I : in STD_LOGIC_VECTOR(3 downto 0);
      	E : out STD_LOGIC_VECTOR(3 downto 0);
      	P : out STD_LOGIC_VECTOR(7 downto 0));

end bintohex;

architecture Behavioral of bintohex is

begin
	E <= "0111";  --The enables the leftmost digit of the seven segment display.
	process (I) is
	begin
    	case (I) is	--This case statment does the actual decoding to drive the 7 segment display.
    	when "0000" => P <= not "00111111";
    	when "0001" => P <= not "00000110";
    	when "0010" => P <= not "01011011";
    	when "0011" => P <= not "01001111";
    	when "0100" => P <= not "01100110";
    	when "0101" => P <= not "01101101";
    	when "0110" => P <= not "01111101";
    	when "0111" => P <= not "00000111";
    	when "1000" => P <= not "01111111";
    	when "1001" => P <= not "01100111";
    	when "1010" => P <= not "01110111";
    	when "1011" => P <= not "01111100";
    	when "1100" => P <= not "00111001";
    	when "1101" => P <= not "01011110";
    	when "1110" => P <= not "01111001";
    	when "1111" => P <= not "01110001";
    	when others => P <= not "00000000";
	end case;
	end process;
end Behavioral;
