-----------------------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Description: This FSM reads which buttons are pressed and send it to output which is then sent to the MCU.
--              The FSM controller latches for 12 micro seconds signaling the controller to output the value of
--              A. After that the FSM pulses the clock every 6 micro seconds to read the remaining inputs in the 
--              following sequence : B, select, start, up, down, left and right. 
-----------------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NES_CONTROLLER_READER is port ( CLK, RST     : in STD_LOGIC;
                                       CLK_OUT      : out STD_LOGIC := '0';
                                       LATCH_OUT    : out STD_LOGIC := '0';
                                       DATA         : in STD_LOGIC;
                                       DATA_OUT     : out STD_LOGIC_VECTOR(7 downto 0));
end NES_CONTROLLER_READER;

architecture Behavioral of NES_CONTROLLER_READER is
    
    -- Define states ----------------------------------------------------------------------------------------------
    type   CON_TYPE is (LATCH, READ_A, READ_B, READ_SEL, READ_STRT, READ_UP, READ_DOWN, READ_LEFT, READ_RIGHT);
    signal PS : CON_TYPE;
    signal NS : CON_TYPE := LATCH;
    signal A, B, SEL, STRT, UP, DOWN, LEFT, RIGHT : STD_LOGIC := '0';
    signal STATE_COUNT : integer := 0;

    begin
        -- Change state on rising clock edge
        ST_PROC: process (CLK) 
        begin
            if (rising_edge(CLK)) then
                PS <= NS;
            end if;
        end process ST_PROC;
    
    
        -- State decoder for the NES FSM 
        NES_FSM: process (PS, RST, CLK)
        begin
            if (rising_edge(CLK)) then
                
                CLK_OUT <= '0';
                LATCH_OUT <= '0';
                
                case (PS) is
                
                ------------------- Latch state----------------------------------------------------------------
                    when LATCH => 
                        LATCH_OUT <= '1';
                        if (STATE_COUNT < 1200) then        --- hold latch for 12 micro seconds so that the NES 
                            STATE_COUNT <= STATE_COUNT + 1; --- controller output the current value of the buttons   
                        elsif (STATE_COUNT = 1200) then     
                            STATE_COUNT <= 0;               --- got to read button A
                            NS <= READ_A;
                        end if;
                
                ------------------- Read button A ---------------------------------------------------------------
                    when READ_A =>
                        A <= DATA;
                        if (STATE_COUNT < 600) then         --- read button A ( 6 micro second pulse ) 
                            STATE_COUNT <= STATE_COUNT + 1;
                        elsif (STATE_COUNT = 600) then
                            STATE_COUNT <= 0;
                            NS <= READ_B;                   --- go to read button B
                        end if;
                
                ------------------- Read button B ---------------------------------------------------------------
                    when READ_B =>
                        if (STATE_COUNT < 1200) then
                            STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------
                        
                        if (STATE_COUNT = 600) then         --- read button B ( 6 micro second pulse ) 
                            B <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- go to read select button 
                            STATE_COUNT <= 0;
                            NS <= READ_SEL;
                        end if;
                    
                ------------------- Read select button ------------------------------------------------------------
                    when READ_SEL =>
                        if (STATE_COUNT < 1200) then
                        STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------

                        if (STATE_COUNT = 600) then         --- read select button ( 6 micro second pulse ) 
                            SEL <= DATA;
                        end if;
                    
                        if (STATE_COUNT = 1200) then        --- go to read start button
                            STATE_COUNT <= 0;
                            NS <= READ_STRT;
                        end if;  
                    
                ------------------- Read start button --------------------------------------------------------------
                    when READ_STRT =>
                        if (STATE_COUNT < 1200) then
                            STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------

                        if (STATE_COUNT = 600) then         --- read start button ( 6 micro second pulse )
                            STRT <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- go to read up button
                            STATE_COUNT <= 0;
                            NS <= READ_UP;
                        end if;  
                        
                ------------------- Read up button  ---------------------------------------------------------------
                    when READ_UP =>
                        if (STATE_COUNT < 1200) then
                        STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------

                        if (STATE_COUNT = 600) then         --- read up button ( 6 micro second pulse )
                            UP <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- go to read down button
                            STATE_COUNT <= 0;
                            NS <= READ_DOWN;
                        end if;  
                        
                ------------------- Read down button ---------------------------------------------------------------
                    when READ_DOWN =>
                        if (STATE_COUNT < 1200) then
                        STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------
                        
                        if (STATE_COUNT = 600) then         --- read down button ( 6 micro second pulse )
                            DOWN <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- go to read left button
                            STATE_COUNT  <= 0;
                            NS <= READ_LEFT;
                        end if;   
                       
                ------------------- Read left button ---------------------------------------------------------------
                    when READ_LEFT =>
                        if (STATE_COUNT < 1200) then
                        STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------

                        if (STATE_COUNT = 600) then         --- read left button ( 6 micro second pulse )
                            LEFT <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- go to read right button
                            STATE_COUNT <= 0;
                            NS <= READ_RIGHT;
                        end if;  
                        
                ------------------- Read right button ---------------------------------------------------------------
                    when READ_RIGHT =>
                        if (STATE_COUNT < 1200) then
                        STATE_COUNT <= STATE_COUNT + 1;
                        end if;
                        
                        ------------------------ this clock signals to the NES controller to send next input ---
                        if (STATE_COUNT <= 600) then
                            CLK_OUT <= '1';
                        elsif (STATE_COUNT > 600) then
                            CLK_OUT <= '0';
                        end if;
                        -----------------------------------------------------------------------------------------

                        if (STATE_COUNT = 600) then         --- read right button ( 6 micro second pulse )
                            RIGHT <= DATA;
                        end if;
                        
                        if (STATE_COUNT = 1200) then        --- return to latch state
                            STATE_COUNT <= 0;
                            NS <= LATCH;
                        end if;                  
                end case;
                
                --- Concatenate the individual bits for to indicate button is pressed and send to ouput
                DATA_OUT <= not B & not A & not SEL & not STRT & not RIGHT & not DOWN & not LEFT & not UP;
            end if;
            
        end process;

end Behavioral;
