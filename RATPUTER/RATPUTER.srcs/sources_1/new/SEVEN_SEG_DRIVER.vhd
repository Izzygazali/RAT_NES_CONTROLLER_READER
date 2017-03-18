library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SEVEN_SEG_DRIVER is
    Port ( HEX_INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           ANODE : in STD_LOGIC_VECTOR (3 downto 0);
           CATHODE : out STD_LOGIC_VECTOR (7 downto 0));
end SEVEN_SEG_DRIVER;

architecture Behavioral of SEVEN_SEG_DRIVER is
signal s_SLOW_CLOCK : STD_LOGIC := '0';
begin
    CLOCK_DIV : process (CLK, RST)
        variable count : std_logic_vector(29 downto 0) := (others => '0');
        begin
            if (RST = '1') then 
                s_SLOW_CLOCK <= '0';
                count := (others => '0');    
            else
                if (rising_edge(CLK)) then
                    if (count >= (std_logic_vector(to_unsigned(104166, 29)))) then
                        s_SLOW_CLOCK  <= NOT(s_SLOW_CLOCK);
                        count := (others => '0');
                    else
                        count := count + 1;
                    end if;
                end if;
            end if;
    end process CLOCK_DIV; 



end Behavioral;
