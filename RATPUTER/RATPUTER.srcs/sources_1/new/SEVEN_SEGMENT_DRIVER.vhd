library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SEVEN_SEGMENT_DRIVER is
   Port ( 
     number : in STD_LOGIC_VECTOR(9 downto 0);
     sel : out STD_LOGIC_VECTOR (3 downto 0);
     digit : out STD_LOGIC_VECTOR (7 downto 0);
     RST, CLK : in STD_LOGIC
   );
end SEVEN_SEGMENT_DRIVER;
 
architecture Behavioral of SEVEN_SEGMENT_DRIVER is

signal hundreds, tens, ones, s_digit : std_logic_vector (3 downto 0);
signal s_CLK : STD_LOGIC := '0';
signal bcd_number : STD_LOGIC_VECTOR(15 downto 0);
begin

   bcd_number <= "0000"&hundreds&tens&ones;
   
   bin_to_bcd : process (number)
      -- Internal variable for storing bits
      variable shift : unsigned(21 downto 0);
      
	  -- Alias for parts of shift register
      alias num is shift(9 downto 0);
      alias one is shift(13 downto 10);
      alias ten is shift(17 downto 14);
      alias hun is shift(21 downto 18);
   begin
      -- Clear previous number and store new number in shift register
      num := unsigned(number);
      one := X"0";
      ten := X"0";
      hun := X"0";
      
	  -- Loop eight times
      for i in 1 to num'Length loop
	     -- Check if any digit is greater than or equal to 5
         if one >= 5 then
            one := one + 3;
         end if;
         
         if ten >= 5 then
            ten := ten + 3;
         end if;
         
         if hun >= 5 then
            hun := hun + 3;
         end if;
         
		 -- Shift entire register left once
         shift := shift_left(shift, 1);
      end loop;
      
	  -- Push decimal numbers to output
      hundreds <= std_logic_vector(hun);
      tens     <= std_logic_vector(ten);
      ones     <= std_logic_vector(one);
   end process;
   
   clock : process (CLK, RST)
       variable count : std_logic_vector(29 downto 0) := (others => '0');
       begin
           if (RST = '1') then 
               s_CLK <= '0';
               count := (others => '0');    
           else
               if (rising_edge(CLK)) then
                   if (count >= (std_logic_vector(to_unsigned(104166, 29)))) then
                       s_CLK  <= NOT(s_CLK);
                       count := (others => '0');
                   else
                       count := count + 1;
                   end if;
               end if;
           end if;
   end process clock; 
   
   process (clk)
   variable digCnt : std_logic_vector(3 downto 0) := "0000";
   begin
   if ( rising_edge(clk)) then
           if (digCnt = "0000") then
               s_digit <= bcd_number(3 downto 0);
               sel <= "1110";
               digCnt := digCnt + "0001";
           elsif (digCnt = "0001") then
               s_digit <= bcd_number(7 downto 4);
               sel <= "1101";
               digCnt := digCnt + "0001";
           elsif (digCnt = "0010") then
               s_digit <= bcd_number(11 downto 8);
               sel <= "1011";
               digCnt := digCnt + "0001";
           elsif (digCnt = "0011") then 
               s_digit <= bcd_number(15 downto 12);
               digCnt := "0000";
               sel <= "1111";
           end if;
   end if;
   end process;
   process (s_digit) is begin
           case (s_digit) is 
               when "0000" => digit <= not "00111111";
               when "0001" => digit <= not "00000110";
               when "0010" => digit <= not "01011011";
               when "0011" => digit <= not "01001111";
               when "0100" => digit <= not "01100110";
               when "0101" => digit <= not "01101101";
               when "0110" => digit <= not "01111101";
               when "0111" => digit <= not "00000111";
               when "1000" => digit <= not "01111111";
               when "1001" => digit <= not "01100111";
               when "1010" => digit <= not "01110111";
               when "1011" => digit <= not "01111100";
               when "1100" => digit <= not "00111001";
               when "1101" => digit <= not "01010000";
               when "1110" => digit <= not "01111001";
               when "1111" => digit <= not "00000000";
               when others => digit <= not "00000000";
           end case;
        end process;


   end Behavioral;
