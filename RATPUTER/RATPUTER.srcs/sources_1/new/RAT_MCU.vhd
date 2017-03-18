----------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Create Date: 02/08/2017 09:36:38 AM
-- Project Name: RATPUTER
-- Description: This VHDL module contains the parts of the RAT MCU that have been
--              created in experiments 3-7. The Module resembles the RAT MCU 
--              although it is not fully functional yet.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAT_MCU is port (IN_PORT : in    STD_LOGIC_VECTOR(7 downto 0);
                        RESET   : in    STD_LOGIC;
                        INT_IN  : in    STD_LOGIC;
                        CLK     : in    STD_LOGIC;
                        OUT_PORT: out   STD_LOGIC_VECTOR(7 downto 0);
                        PORT_ID : out   STD_LOGIC_VECTOR(7 downto 0);
                        IO_STRB : out   STD_LOGIC);
end RAT_MCU;

architecture Behavioral of RAT_MCU is

    -- Declare MCU components ----------------------------------------------------------
    component ALU is
    Port ( A        : in STD_LOGIC_VECTOR (7 downto 0);
           B        : in STD_LOGIC_VECTOR (7 downto 0);
           SEL      : in STD_LOGIC_VECTOR (3 downto 0);
           Cin      : in STD_LOGIC;
           RESULT   : out STD_LOGIC_VECTOR (7 downto 0);
           C        : out STD_LOGIC;
           Z        : out STD_LOGIC);
    end component;
    
    component CONTROL_UNIT is
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
    end component;
    
    component REG_FILE is
    Port ( ADDX, ADDY   : in STD_LOGIC_VECTOR (4 downto 0);
           DIN          : in STD_LOGIC_VECTOR (7 downto 0);
           DX_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
           WR, CLK      : in STD_LOGIC);
    end component;
    
    component PC_MUX is 
    Port(FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
         FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
         PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
         TO_PC_DIN  : out STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component PC is 
    Port(  Din      : in STD_LOGIC_VECTOR (9 downto 0);       
           PC_LD    : in STD_LOGIC;                          
           PC_INC   : in STD_LOGIC;                        
           RST      : in STD_LOGIC;                            
           CLK      : in STD_LOGIC;                        
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0)); 
    end component;
    
    component ALU_MUX is 
    Port ( FROM_REG     : in STD_LOGIC_VECTOR (7 downto 0);
           FROM_IMMED   : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_OPY_SEL  : in STD_LOGIC;
           TO_B         : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component RF_MUX is 
    Port ( IN_PORT      : in STD_LOGIC_VECTOR (7 downto 0);
           STACK_PTR    : in STD_LOGIC_VECTOR (7 downto 0);
           SCRATCH      : in STD_LOGIC_VECTOR (7 downto 0);
           ALU_RESULT   : in STD_LOGIC_VECTOR (7 downto 0);
           RF_WR_SEL    : in STD_LOGIC_VECTOR(1 downto 0);
           TO_DIN       : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component prog_rom is 
    port ( ADDRESS      : in std_logic_vector(9 downto 0); 
           INSTRUCTION  : out std_logic_vector(17 downto 0); 
           CLK          : in std_logic);  
    end component;
    
    component FLAGS is 
    Port( FLG_C_SET     : in STD_LOGIC;
          FLG_C_CLR     : in STD_LOGIC;
          FLG_C_LD      : in STD_LOGIC;
          FLG_Z_LD      : in STD_LOGIC;
          FLG_LD_SEL    : in STD_LOGIC;
          FLG_SHAD_LD   : in STD_LOGIC;
          C             : in STD_LOGIC;
          Z             : in STD_LOGIC;
          CLK           : in STD_LOGIC;
          C_FLAG        : out STD_LOGIC;
          Z_FLAG        : out STD_LOGIC);
    end component;
    
    component SCR is 
    port( SCR_ADDR      : in STD_LOGIC_VECTOR (7 downto 0);        
          SCR_WE        : in STD_LOGIC;                               
          SCR_DATA_IN   : in STD_LOGIC_VECTOR (9 downto 0);     
          CLK           : in STD_LOGIC;                                  
          SCR_DATA_OUT  : out STD_LOGIC_VECTOR (9 downto 0));  
    end component;
    
    component SCR_ADDR_MUX is 
    port( SCR_ADDR_SEL           : in STD_LOGIC_VECTOR (1 downto 0);
          ADDR_FROM_DY           : in STD_LOGIC_VECTOR (7 downto 0);
          ADDR_FROM_IR           : in STD_LOGIC_VECTOR (7 downto 0);
          ADDR_FROM_SP           : in STD_LOGIC_VECTOR (7 downto 0);
          ADDR_FROM_SP_MINUS_ONE : in STD_LOGIC_VECTOR (7 downto 0);
          TO_ADDR_SCR            : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component SCR_DATA_MUX is 
    port( SCR_DATA_SEL   : in STD_LOGIC;
          TO_DATA_IN_SCR : out STD_LOGIC_VECTOR (9 downto 0);
          DATA_FROM_DX   : in STD_LOGIC_VECTOR (7 downto 0);
          DATA_FROM_PC   : in STD_LOGIC_VECTOR (9 downto 0));
    end component;
    
    component SP is 
    Port( RST       : in STD_LOGIC;
          SP_LD     : in STD_LOGIC;
          SP_INCR   : in STD_LOGIC;
          SP_DECR   : in STD_LOGIC;
          A_DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
          DATA_OUT  : out STD_LOGIC_VECTOR (7 downto 0);
          CLK       : in STD_LOGIC);
    end component;
    
    component I is 
    Port( I_SET : in STD_LOGIC;
          I_CLR : in STD_LOGIC;
          CLK   : in STD_LOGIC;
          I_OUT : out STD_LOGIC);
    end component;
    
    -- Define Signals ------------------------------------------------------------
    -- All signals are defined by the output that drives them
    signal s_IR                                                         : STD_LOGIC_VECTOR(17 downto 0);
    signal s_TO_PC_DIN, s_PC_COUNT, s_SCR_DATA_OUT, s_TO_DATA_IN_SCR    : STD_LOGIC_VECTOR(9 downto 0);
    signal s_SP_DATA_OUT, s_RESULT, s_TO_REG_DIN, s_DX_OUT, s_DY_OUT, 
           s_TO_ALU_B, s_TO_ADDR_SCR                                    : STD_LOGIC_VECTOR(7 downto 0);
    signal s_ALU_SEL                                                    : STD_LOGIC_VECTOR(3 downto 0);
    signal s_PC_MUX_SEL, s_SCR_ADDR_SEL, s_RF_WR_SEL                    : STD_LOGIC_VECTOR(1 downto 0);
    signal s_RST, s_PC_LD, s_PC_INC, s_C_FLAG, s_Z_FLAG, s_INT, 
           s_FLG_SHAD_LD, s_FLG_LD_SEL, s_FLG_Z_LD, s_FLG_C_LD, 
           s_FLG_C_CLR, s_FLG_C_SET, s_SCR_DATA_SEL, s_SCR_WE,s_SP_DECR, 
           s_SP_INCR, s_SP_LD, s_RF_WR,s_ALU_OPY_SEL, s_I_SET, s_I_CLR, 
           s_C_ALU, s_Z_ALU, s_I_OUT                                    : STD_LOGIC;
    
    -- Port Maps ------------------------------------------------------------------
    -- The following port maps route the modules together according to the description in the Lab manual and following
    -- the RAT MCU architecture.
    begin
        OUT_PORT <= s_DX_OUT;
        PORT_ID <= s_IR(7 downto 0);
        s_INT <= s_I_OUT and INT_IN;
        
        P_MUX: 
        PC_MUX port map (FROM_IMMED => s_IR(12 downto 3), FROM_STACK => s_SCR_DATA_OUT, 
                         PC_MUX_SEL => s_PC_MUX_SEL, TO_PC_DIN => s_TO_PC_DIN);
        
        
        P_CNT: 
        PC port map (RST => s_RST, PC_LD => s_PC_LD, PC_INC => s_PC_INC, DIN => s_TO_PC_DIN,  
                     CLK => CLK, PC_COUNT => s_PC_COUNT);
                                             
        
                                             
        P_ROM: 
        prog_rom port map (ADDRESS => s_PC_COUNT, CLK => CLK, INSTRUCTION => s_IR);
        
        C_UNIT: 
        CONTROL_UNIT port map(C => s_C_FLAG, Z => s_Z_FLAG, INT => s_INT, RESET => RESET,
                              OPCODE_HI_5 => s_IR(17 downto 13), OPCODE_LO_2 => s_IR(1 downto 0), 
                              CLK => CLK, I_SET => s_I_SET, I_CLR => s_I_CLR, PC_LD => s_PC_LD,
                              PC_INC => s_PC_INC, ALU_OPY_SEL => s_ALU_OPY_SEL, RF_WR => s_RF_WR, 
                              SP_LD => s_SP_LD, IO_STRB => IO_STRB, SP_INCR => s_SP_INCR, 
                              SP_DECR => s_SP_DECR, SCR_WE => s_SCR_WE, SCR_DATA_SEL => s_SCR_DATA_SEL, 
                              FLG_C_SET => s_FLG_C_SET, FLG_C_CLR => s_FLG_C_CLR, FLG_C_LD => s_FLG_C_LD, 
                              FLG_Z_LD => s_FLG_Z_LD, FLG_LD_SEL => s_FLG_LD_SEL, FLG_SHAD_lD => s_FLG_SHAD_LD, 
                              RST => s_RST, PC_MUX_SEL => s_PC_MUX_SEL, RF_WR_SEL => s_RF_WR_SEL, 
                              SCR_ADDR_SEL => s_SCR_ADDR_SEL, ALU_SEL => s_ALU_SEL);
        
        R_MUX: 
        RF_MUX port map (IN_PORT => IN_PORT, STACK_PTR => s_SP_DATA_OUT, SCRATCH => s_SCR_DATA_OUT(7 downto 0), 
                         ALU_RESULT => s_RESULT, RF_WR_SEL => s_RF_WR_SEL, TO_DIN => s_TO_REG_DIN);
       
        R_FILE: 
        REG_FILE port map(ADDX => s_IR(12 downto 8), ADDY  => s_IR(7 downto 3), DIN  => s_TO_REG_DIN,
                          DX_OUT => s_DX_OUT, DY_OUT => s_DY_OUT, WR => s_RF_WR, CLK => CLK);
        
        A_MUX: 
        ALU_MUX port map (FROM_REG => s_DY_OUT, FROM_IMMED => s_IR(7 downto 0), ALU_OPY_SEL => s_ALU_OPY_SEL,
                          TO_B => s_TO_ALU_B);
        
        A_UNIT: 
        ALU port map (A => s_DX_OUT, B => s_TO_ALU_B, SEL => s_ALU_SEL, Cin => s_C_FLAG, RESULT => s_RESULT,
                      C => s_C_ALU, Z => s_Z_ALU);

        F_UNIT: 
        FLAGS port map (FLG_C_SET => s_FLG_C_SET, FLG_C_CLR => s_FLG_C_CLR, FLG_C_LD => s_FLG_C_LD,
                        FLG_Z_LD => s_FLG_Z_LD, FLG_LD_SEL => s_FLG_LD_SEL, FLG_SHAD_LD => s_FLG_SHAD_LD,
                        C => s_C_ALU, Z => s_Z_ALU, CLK => CLK, C_FLAG => s_C_FLAG, Z_FLAG => s_Z_FLAG);
        
        SP_UNIT: 
        SP port map (RST => s_RST, SP_LD => s_SP_LD, SP_INCR => s_SP_INCR, SP_DECR => s_SP_DECR, 
                     A_DATA_IN => s_DX_OUT, CLK => CLK, DATA_OUT => s_SP_DATA_OUT );
        
        SCR_MUX_ADDR: 
        SCR_ADDR_MUX port map (SCR_ADDR_SEL => s_SCR_ADDR_SEL, ADDR_FROM_DY => s_DY_OUT, ADDR_FROM_IR => s_IR(7 downto 0),
                               ADDR_FROM_SP => s_SP_DATA_OUT ,ADDR_FROM_SP_MINUS_ONE => s_SP_DATA_OUT,
                               TO_ADDR_SCR => s_TO_ADDR_SCR);
        
        SCR_MUX_DATA: 
        SCR_DATA_MUX port map  (SCR_DATA_SEL => s_SCR_DATA_SEL, DATA_FROM_DX => s_DX_OUT, DATA_FROM_PC => s_PC_COUNT,
                                TO_DATA_IN_SCR => s_TO_DATA_IN_SCR);
        SCR_UNIT:  
        SCR port map (SCR_ADDR => s_TO_ADDR_SCR, SCR_WE => s_SCR_WE, SCR_DATA_IN => s_TO_DATA_IN_SCR,
                      CLK => CLK, SCR_DATA_OUT => s_SCR_DATA_OUT);
        
        I_UNIT:  
        I port map (I_SET => s_I_SET, I_CLR => s_I_CLR, CLK => CLK, I_OUT => s_I_OUT);
                                                           
end Behavioral;
