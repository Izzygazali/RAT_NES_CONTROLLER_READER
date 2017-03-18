----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/06/2017 10:00:01 AM
-- Description: This VHDL module implements the control unit for the RAT MCU.
--              It is implemented as a finite statemachine and contains the logic to
--              coordinate other modules to carry out the operations of the MCU.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Control Unit inputs/outputs are as described in the RAT Architecture diagram.
entity CONTROL_UNIT is  
    Port ( C 		   					       : in STD_LOGIC;
           Z 		   					       : in STD_LOGIC;
           INT 		   					       : in STD_LOGIC;
           RESET 	   					       : in STD_LOGIC;
           OPCODE_HI_5 					       : in STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2 					       : in STD_LOGIC_VECTOR (1 downto 0);
           CLK 		   					   	   : in STD_LOGIC;
           I_SET, I_CLR, PC_LD, PC_INC, 
           ALU_OPY_SEL, RF_WR, SP_LD, IO_STRB, 
           SP_INCR, SP_DECR, SCR_WE, 
           SCR_DATA_SEL, FLG_C_SET, 
           FLG_C_CLR, FLG_C_LD, FLG_Z_LD, 
           FLG_LD_SEL, FLG_SHAD_lD, RST        : out STD_LOGIC;
           PC_MUX_SEL, RF_WR_SEL, SCR_ADDR_SEL : out STD_LOGIC_VECTOR(1 downto 0);
    	   ALU_SEL							   : out STD_LOGIC_VECTOR(3 downto 0));
end CONTROL_UNIT;


architecture Behavioral of CONTROL_UNIT is
    ---- "00" initialize state
    ---- "01" interrupt state
    ---- "10" fetch state
    ---- "11" execute
    signal PS, NS   : STD_LOGIC_VECTOR(1 downto 0); 
    signal OP_CODE  : STD_LOGIC_VECTOR(6 downto 0);

    begin
    
        OP_CODE <= OPCODE_HI_5 & OPCODE_LO_2;       --combine important parts of opcode into one signal.
    
        state: process (CLK, RESET) begin           --This is the state register of the control unit FSM.
            if (RESET = '1') then                   --If we are reseting go to initialize state
                PS <= "00";
            elsif (rising_edge(CLK)) then           --if were aren't reseting go to the next state.
                PS <= NS;
            end if;
        end process state;
         
        statedecoder: process (PS, OP_CODE) begin --This is the input/ouput decoder for our control unit FSM.
            --Set all control signals to default to remove possibility of contamination from previous cycles.
            I_SET <= '0';         I_CLR <= '0'; 	 PC_LD <= '0';       PC_INC <= '0';   ALU_OPY_SEL <= '0';
            RF_WR <= '0'; 		  SP_LD <= '0'; 	 SP_INCR <= '0';     SP_DECR <= '0';  SCR_WE <= '0'; 
            SCR_DATA_SEL <= '0';  FLG_C_SET <= '0';  FLG_C_CLR <= '0';   FLG_C_LD <= '0'; PC_MUX_SEL <= "00";
            FLG_Z_LD <= '0';      FLG_LD_SEL <= '0'; FLG_SHAD_lD <= '0'; RST <= '0';      RF_WR_SEL <= "00";
            SCR_ADDR_SEL <= "00"; ALU_SEL <= "0000"; IO_STRB <= '0';							   
            
            case (PS) is
            ---------------------- INTIALIZE STATE --------------------------------------------------------------
                when "00" =>                --when in init state go to fetch and reset.
                    NS <= "10";
                    RST <= '1';
                    
            ---------------------- INTERRUPT STATE --------------------------------------------------------------
                when "01" =>                --when in interupt state go to fetch and interupt.
                    NS <= "10";
                    PC_LD <= '1'; SP_DECR <= '1';  SCR_WE <= '1'; SCR_DATA_SEL <= '1';  
                    PC_MUX_SEL <= "10"; FLG_SHAD_lD <= '1'; SCR_ADDR_SEL <= "11";   
                    
            ---------------------- FETCH STATE ------------------------------------------------------------------
                when "10" =>                --when in fetch state go to exec state and increment counter.
                    NS <= "11";
                    PC_INC <= '1';
                    
            ---------------------- EXECUTE STATE ----------------------------------------------------------------                    
                when "11" =>                --when in exec state, if INT is asserted go to interrupt state
                                            --otherwise return to fetch state. 
                    if (INT = '1') then
                        NS <= "01";
                    else 
                        NS <= "10";
                    end if;
                    
                    
                    
                    case (OP_CODE) is       --modify signals to perform desired operations
                       
                        when "0000100" => -------------------------------------------------- Add Reg
                            ALU_OPY_SEL <= '0'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0000";                                          
                        
                        when "1010000" | "1010001" | "1010010" | "1010011" => -------------- Add Immd
                            ALU_OPY_SEL <= '1'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0000"; 
                        
                        when "0000101" => -------------------------------------------------- AddC Reg
                            ALU_OPY_SEL <= '0'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0001";         
                        
                        when "1010100" | "1010101" | "1010110" | "1010111" => -------------- AddC Immed                
                            ALU_OPY_SEL <= '1'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0001";                    
                        
                        when "0000000" => -------------------------------------------------- AND Reg
                            ALU_OPY_SEL <= '0'; RF_WR <= '1'; FLG_Z_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "0101";              
                        
                        when "1000000" | "1000001" | "1000010" | "1000011" => -------------- AND Immed
                            ALU_OPY_SEL <= '1'; RF_WR <= '1'; FLG_Z_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "0101";     
                        
                        when "0100100" => -------------------------------------------------- ASR Reg
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "1101";                
                        
                        when "0010101" => -------------------------------------------------- BRCC
                            if (C = '0') then
                                PC_MUX_SEL <= "00";
                                PC_LD <= '1';
                            end if;                    
                                         
                        when "0010100" => --------------------------------------------------- BRCS
                            if (C = '1') then
                                PC_MUX_SEL <= "00";
                                PC_LD <= '1';
                            end if;      
                                
                        when "0010010" => --------------------------------------------------- BREQ
                            if (Z = '1') then
                                PC_MUX_SEL <= "00";
                                PC_LD <= '1';
                            end if;        
                                
                        when "0010000" => --------------------------------------------------- BRN
                            PC_MUX_SEL <= "00"; PC_LD <= '1';   
                                    
                        when "0010011" => --------------------------------------------------- BRNE
                            if (Z = '0') then
                                PC_MUX_SEL <= "00";
                                PC_LD <= '1';
                            end if;
                        
                        when "0010001" => --------------------------------------------------- Call
                            PC_LD <= '1'; SP_DECR <= '1';  SCR_WE <= '1'; 
                            SCR_DATA_SEL <= '1'; PC_MUX_SEL <= "00"; SCR_ADDR_SEL <= "11";     
                        
                        when "0110101" => --------------------------------------------------- CLI
                            I_CLR <= '1'; 
                            
                        when "0110000" => --------------------------------------------------- CLC
                            FLG_C_CLR <= '1'; 
    
                        when "1100000" | "1100001" | "1100010" | "1100011" => --------------- CMP Immed
                            FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            ALU_OPY_SEL <= '1'; ALU_SEL <= "0100";                              
                                                      
                        when "0001000" => --------------------------------------------------- CMP Reg
                            FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            ALU_OPY_SEL <= '0'; ALU_SEL <= "0100";
        
                        when "0000010" => --------------------------------------------------- EXOR Reg
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_CLR <= '1';  
                            RF_WR_SEL <= "00"; ALU_OPY_SEL <= '0'; ALU_SEL <= "0111";  
                        
                        when "1001000" | "1001001" | "1001010" | "1001011" => --------------- EXOR Immed
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_CLR <= '1';  
                            RF_WR_SEL <= "00"; ALU_OPY_SEL <= '1'; ALU_SEL <= "0111";  
                                                                                                                                                     
                        when "1100100" | "1100101" | "1100110" | "1100111" => --------------- IN
                            RF_WR <= '1'; RF_WR_SEL <= "11"; IO_STRB <= '0';
     
                        when "0001010" => --------------------------------------------------- LD reg
                            RF_WR <= '1'; RF_WR_SEL <= "01"; SCR_ADDR_SEL <= "00";                                
      
                        when "1110000" | "1110001" | "1110010" | "1110011" => --------------- LD Immed
                            RF_WR <= '1'; RF_WR_SEL <= "01"; SCR_ADDR_SEL <= "01";
                                                      
                        when "0100000" => --------------------------------------------------- LSL 
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "1001";                         
    
                        when "0100001" => --------------------------------------------------- LSR 
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "1010";                     
                        
                        when "0001001" => --------------------------------------------------- MOV REG
                            RF_WR <= '1'; RF_WR_SEL <= "00"; ALU_SEL <= "1110";  
                            ALU_OPY_SEL <= '0';                      
                        
                        when "1101100"| "1101101" | "1101110" | "1101111" => ---------------- MOV IMMED                    
                            RF_WR <= '1'; RF_WR_SEL <= "00"; ALU_SEL <= "1110"; 
                            ALU_OPY_SEL <= '1';                    
                        
                        when "0000001" => --------------------------------------------------- OR Reg
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_CLR <= '1';  
                            RF_WR_SEL <= "00"; ALU_OPY_SEL <= '0'; ALU_SEL <= "0110";                      
                        
                        when "1000100" | "1000101" | "1000110" | "1000111" => --------------- OR Immed
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_CLR <= '1';  
                            RF_WR_SEL <= "00"; ALU_OPY_SEL <= '1'; ALU_SEL <= "0110";                    
                        
                        when "1101000" | "1101001" | "1101010" | "1101011" => --------------- OUT
                            IO_STRB <= '1';                     
                        
                        when "0100110" => --------------------------------------------------- POP
                            RF_WR <= '1'; RF_WR_SEL <= "01"; SCR_ADDR_SEL <= "10";                         
                            SP_INCR <= '1';
                        
                        when "0100101" => --------------------------------------------------- PUSH
                            SP_DECR <= '1';  SCR_WE <= '1'; SCR_DATA_SEL <= '0'; 
                            SCR_ADDR_SEL <= "11";                   
                        
                        when "0110010" => --------------------------------------------------- RET
                            PC_LD <= '1'; SP_INCR <= '1'; PC_MUX_SEL <= "01";      
                            SCR_ADDR_SEL <= "10";                     
                        
                        when "0110111" => --------------------------------------------------- RETIE
                            I_SET <= '1';      PC_LD <= '1';       SP_INCR <= '1'; 
                            FLG_C_LD <= '1';   PC_MUX_SEL <= "01"; FLG_Z_LD <= '1';      
                            FLG_LD_SEL <= '1'; SCR_ADDR_SEL <= "10";                            
                        
                        when "0110110" => --------------------------------------------------- RETID
                            I_CLR <= '1';        PC_LD <= '1';       SP_INCR <= '1'; 
                            FLG_C_LD <= '1';   PC_MUX_SEL <= "01"; FLG_Z_LD <= '1';      
                            FLG_LD_SEL <= '1'; SCR_ADDR_SEL <= "10"; 
                        
                        when "0100010" => --------------------------------------------------- ROL
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "1011";    
                        
                        when "0100011" => --------------------------------------------------- ROR
                            RF_WR <= '1'; FLG_Z_LD <= '1'; FLG_C_LD <= '1';  
                            RF_WR_SEL <= "00"; ALU_SEL <= "1100"; 
                        
                        when "0110001" => --------------------------------------------------- SETC
                            FLG_C_SET <= '1';
                        
                        when "0110100" => --------------------------------------------------- SEI
                            I_SET <= '1';  
                        
                        when "0001011" => --------------------------------------------------- ST Reg
                            SCR_WE <= '1'; SCR_DATA_SEL <= '0'; SCR_ADDR_SEL <= "00";
                        
                        when "1110100" | "1110101" | "1110110" | "1110111" => --------------- ST Immed     
                            SCR_WE <= '1'; SCR_DATA_SEL <= '0'; SCR_ADDR_SEL <= "01";     
                        
                        when "0000110" => --------------------------------------------------- SUB REG
                            ALU_OPY_SEL <= '0'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0010"; 
                        
                        when "1011000" | "1011001" | "1011010" | "1011011" => --------------- SUB Immed
                            ALU_OPY_SEL <= '1'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0010";      
                        
                        when "0000111" => --------------------------------------------------- SUBC REG
                            ALU_OPY_SEL <= '0'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0011"; 
                        
                        when "1011100" | "1011101" | "1011110" | "1011111" => --------------- SUBC Immed
                            ALU_OPY_SEL <= '1'; RF_WR <= '1';   FLG_C_LD <= '1';
                            FLG_Z_LD <= '1';  RF_WR_SEL <= "00"; ALU_SEL <= "0011"; 
                        
                        when "0000011" => --------------------------------------------------- TEST Reg
                            ALU_OPY_SEL <= '0'; FLG_Z_LD <= '1'; ALU_SEL <= "1000";   
                            FLG_C_CLR <= '1';      
                        
                        when "1001100" | "1001101" | "1001110" | "1001111" => --------------- TEST Immed
                            ALU_OPY_SEL <= '1'; FLG_Z_LD <= '1'; ALU_SEL <= "1000";   
                            FLG_C_CLR <= '1';                                    
                        
                        when "0101000" => --------------------------------------------------- WSP
                            SP_LD <= '1';                  
                        
                        when others => null; ------------------------------------------------ If not valid OP-CODE do nothing.
                    end case;
                    
                    when others => NS <= "00"; -- If not valid state return to init state.
             end case;       
        end process statedecoder;
    end Behavioral;
    
    
                                             