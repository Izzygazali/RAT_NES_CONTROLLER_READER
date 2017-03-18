----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/08/2017 08:50:29 PM
-- Project Name: FLAGS 
-- Description: This VHDL module handles the RAT MCU's carry, zero, and shadow 
--              flags. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLAGS is port ( FLG_C_SET, FLG_C_CLR, FLG_C_LD, FLG_Z_LD, 
                       FLG_LD_SEL, FLG_SHAD_LD, C, Z, CLK           : in STD_LOGIC;
                       C_FLAG, Z_FLAG                               : out STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is
    
    -- Define input signals 
    signal s_SHAD_Z, s_SHAD_C, s_C_FLAG, s_Z_FLAG : STD_LOGIC;
    
    -- Define outpu signals
    signal s_Z, s_C  : STD_LOGIC; 
    
    begin
        C_FLAG <= s_C_FLAG;
        Z_FLAG <= s_Z_FLAG;

        -- When FlG_LD_SEL is high, load the Z flag with the shadow Z flag. 
        zMUX: process (Z, FLG_LD_SEL) begin
            if (FLG_LD_SEL = '1') then
                s_Z <= s_SHAD_Z;
            else
                s_Z <= Z;    
            end if;
        end process zMUX;
        
        -- When FlG_LD_SEL is high, load the Z flag with the shadow Z flag.       
        cMUX: process (C, FLG_LD_SEL) begin
            if (FLG_LD_SEL = '1') then
                s_C <= s_SHAD_C;
            else
                s_C <= C;    
            end if;        
        end process cMUX;

        process (CLK) 
        begin
            if (rising_edge(CLK)) then
                --Set, Clear, or Load the C flag on the rising clock edge 
                --based on the control signals from the control unit
                if    (FLG_C_CLR = '1') then s_C_FLAG <= '0';
                elsif (FLG_C_SET = '1') then s_C_FLAG <= '1';
                elsif (FLG_C_LD  = '1') then s_C_FLAG <= s_C;
                end if;
                
                --Update the Z flag on the rising clock edge when FLD_Z_LD is high               
                if (FLG_Z_LD = '1') then s_Z_FLAG <= s_Z;    
                end if;
                
                --Update the C and Z shadow flags on the rising clock edge when the
                --FLG_SHAD_LD is high                 
                if (FLG_SHAD_LD = '1') then
                    s_SHAD_C <= s_C_FLAG;
                    s_SHAD_Z <= s_Z_FLAG;
                end if;
            end if;
        end process;
end Behavioral;
