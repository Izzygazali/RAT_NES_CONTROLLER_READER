----------------------------------------------------------------------------------
-- Engineer:        Ezzeddeen Gazali and Tyler Starr
-- Create Date:     01/30/2017 08:38:14 AM
-- Project Name:    Arithmetic Logic Unit 
-- Description:     A VHDL module for the RAT MCU's ALU. The ALU handles the RAT
--                  MCU's arithmetic and logic operations.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is port (A       : in STD_LOGIC_VECTOR (7 downto 0);     -- First Operand
                    B       : in STD_LOGIC_VECTOR (7 downto 0);     -- Second Operand
                    SEL     : in STD_LOGIC_VECTOR (3 downto 0);     -- Operation opcode
                    Cin     : in STD_LOGIC;                         -- Carry in
                    RESULT  : out STD_LOGIC_VECTOR (7 downto 0);    -- ALU output
                    C       : out STD_LOGIC;                        -- Carry out
                    Z       : out STD_LOGIC);                       -- Zero Flag
end ALU;

architecture Behavioral of ALU is
    
    begin
        process (A, B, SEL, Cin)
        variable temp_RESULT : std_logic_vector(8 downto 0):= (others => '0');
        begin
            
            operations: case(SEL) is  
            -- ADD  
            -- RTL: Rd <- Rd + Rs
            -- RTL: Rd <- Rd + immed
            when "0000" =>                                          
                temp_RESULT := std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
            
            -- ADDC (addition including Carry Flag)
            -- RTL: Rd <- Rd + Rs + C
            -- RTL: RD <- Rd + immed + C
            when "0001" =>
                if (Cin = '1') then 
                    temp_RESULT := std_logic_vector(unsigned('0' & A) + unsigned('0' & B) + "000000001");
                else
                    temp_RESULT := std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
                end if;
      
            -- SUB  or CMP
            -- RTL: Rd <- Rd - Rs
            -- RTL: Rd <- Rd - immed
            when "0010" | "0100" =>                                          
                temp_RESULT := std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
              
            -- SUBC (subtract including Carry Flag)
            -- RTL: Rd <- Rd - Rs - C
            -- RTL: RD <- Rd - immed - C
            when "0011" =>
                if (Cin = '1') then 
                    temp_RESULT := std_logic_vector(unsigned('0' & A) - unsigned('0' & B) - "000000001");
                else
                    temp_RESULT := std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
                end if;
        

            -- AND or TEST
            -- RTL: Rd <- Rd . Rs
            -- RTL: Rd <- Rd . immed   
            when "0101" | "1000" => 
                temp_RESULT := ('0' & A) and ('0' & B);
                
            -- OR
            -- RTL: Rd <- Rd + Rs
            -- RTL: Rd <- Rd + immed   
            when "0110" => 
                temp_RESULT :=('0' & A) or ('0' & B);         
                
            -- EXOR
            -- RTL: Rd <- Rd xor Rs
            -- RTL: Rd <- Rd xor immed   
            when "0111" => 
                temp_RESULT := ('0' & A) xor ('0' & B);
                         
            -- LSL (logical left shift)
            -- RTL: Rd <- Rd(6:0) & C, C <- Rd(7)
            when "1001" =>
                temp_RESULT := '0' & A(6 downto 0) & Cin;
                -- C set to MSB of Rd    
                C <= A(7);             
                
            -- LSR (logical right shift) 
            -- RTL: Rd <- C & Rd(7:1), C <- Rd(0)
            when "1010" =>
                temp_RESULT := '0' & Cin & A(7 downto 1);
             -- C set to LSB of Rd    
                C <= A(0);
            
            -- ROL(rotate left)
            -- RTL: Rd <- Rd(6:0) & C, C <- Rd(7)
            when "1011" =>
                temp_RESULT := '0' & A(6 downto 0) & A(7);
                -- C set to MSB of Rd    
                C <= A(7);  
                
            -- ROR(rotate right)
            -- RTL: Rd <- C & Rd(7:1), C <- Rd(0)
            when "1100" =>
                temp_RESULT := '0' & A(0) & A(7 downto 1);
             -- C set to LSB of Rd    
                C <= A(0);    
                
            -- ASR (arithmetic right shift)
            -- RTL: Rd <- Rd(7) & Rd(7) & Rd(6:1), C <- Rd(0)   
            when "1101" => 
                temp_RESULT := '0' & A(7) & A(7) & A(6 downto 1);
                -- C set to LSB of Rd    
                C <= A(0);
     
            -- MOV
            -- RTL: Rd <- Rs
            -- RTL: Rd <- immed  
            when "1110" => 
                temp_RESULT := '0' & B;
      
            when others => null;
            end case;
            
            -- Sets Z flag for all operations
            if (temp_RESULT(7 downto 0) = "00000000") then
               Z <= '1';
            else
               Z <= '0';
            end if; 
           
            Cflag: case (SEL) is
            -- Set C flag for ADD, ADDC, SUB, SUBC, and CMP
            -- C set to MSB to indicate over/underflow.
            when "0000" | "0001" | "0010" | "0011" | "0100" =>                
                C <= temp_RESULT(8);
            
            -- Set C flag for AND, OR, EXOR, and TEST
            -- C cleared
            when "0101" | "0110" | "0111" | "1000"  =>
                C <= '0';
                
            when others => null;
            end case;
            
            RESULT <= temp_RESULT(7 downto 0);   
    end process;
end Behavioral;