----------------------------------------------------------------------------------------
-- Engineer:  Ezzeddeen Gazali and Tyler Starr
-- Create Date:    02/03/2017
-- Description: Wrapper for RAT MCU. This model interfaces the RAT MCU with the 
--              the external modules needed for this project. 
----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAT_wrapper is port ( LEDS              : out STD_LOGIC_VECTOR (7 downto 0);
                             SWITCHES          : in  STD_LOGIC_VECTOR (7 downto 0);
                             SEVEN_SEG_CATHODE : out STD_LOGIC_VECTOR (7 downto 0);
                             SEVEN_SEG_ANODE   : out STD_LOGIC_VECTOR(3 downto 0);
                             CLK_OUT           : out STD_LOGIC;
                             LATCH_OUT         : out STD_LOGIC;
                             BUTTON_PRESS      : in  STD_LOGIC;
                             UART_TX           : out STD_LOGIC;
                             RST               : in  STD_LOGIC;
                             CLK               : in  STD_LOGIC;
                             R_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
                             G_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
                             B_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
                             HSYNC             : out STD_LOGIC;
                             VSYNC             : out STD_LOGIC);
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

   -- INPUT PORT IDS -------------------------------------------------------------------
   -- These constants represent the port IDs for the MUX that determines which input
   -- port is read into the RAT MCU
   CONSTANT SWITCHES_ID     : STD_LOGIC_VECTOR (7 downto 0) := X"20";
   CONSTANT SECOND_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"22";
   CONSTANT MINUTE_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"23";
   CONSTANT NES_DATA_OUT    : STD_LOGIC_VECTOR (7 downto 0) := X"25";
   CONSTANT RAND_NUM        : STD_LOGIC_VECTOR (7 downto 0) := X"26";
   -------------------------------------------------------------------------------------
   
   
   -------------------------------------------------------------------------------------
   -- OUTPUT PORT IDS ------------------------------------------------------------------
   -- These constants represent the port IDs for the MUX that determines where the
   -- output from the MCU goes to   
   CONSTANT LEDS_ID       : STD_LOGIC_VECTOR (7 downto 0) := X"40";
   CONSTANT SEVEN_ID      : STD_LOGIC_VECTOR (7 downto 0) := x"81";
   CONSTANT TX_CON        : STD_LOGIC_VECTOR (7 downto 0) := x"82";
   CONSTANT TX_DATA       : STD_LOGIC_VECTOR (7 downto 0) := x"83";
   CONSTANT VGA_COLUMN    : STD_LOGIC_VECTOR (7 downto 0) := x"84";
   CONSTANT VGA_ROW       : STD_LOGIC_VECTOR (7 downto 0) := x"85";
   CONSTANT VGA_COLOR     : STD_LOGIC_VECTOR (7 downto 0) := x"86";
   CONSTANT VGA_EN        : STD_LOGIC_VECTOR (7 downto 0) := x"88"; 
   -- TIMER_CON: BIT(4) indicates a RESET, BIT(0) indicates a PAUSE
   CONSTANT TIMER_CON     : STD_LOGIC_VECTOR (7 downto 0) := X"89";  

   -------------------------------------------------------------------------------------



   -- Declare Components ---------------------------------------------------------------
   component RAT_MCU
       Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
              OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
              PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
              IO_STRB  : out STD_LOGIC;
              RESET    : in  STD_LOGIC;
              INT_IN   : in  STD_LOGIC;
              CLK      : in  STD_LOGIC);
   end component RAT_MCU;
   
   component SEVEN_SEG_DRIVER
       Port ( HEX_INPUT : in STD_LOGIC_VECTOR (7 downto 0);
              CLK       : in STD_LOGIC;
              RST       : in STD_LOGIC;
              ANODE     : out STD_LOGIC_VECTOR (3 downto 0);
              CATHODE   : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component UART_TX_CTRL 
       Port ( SEND      : in  STD_LOGIC;
              DATA      : in  STD_LOGIC_VECTOR (7 downto 0);
              CLK       : in  STD_LOGIC;
              READY     : out  STD_LOGIC;
              UART_TX   : out  STD_LOGIC);
   end component;
        
   component INT_HANDLER 
       Port ( TIMER_INPUT   : in STD_LOGIC_VECTOR (7 downto 0);
              CLK           : in STD_LOGIC;
              INT_OUT       : out STD_LOGIC);  
   end component;
   
   component static_VGA_wrapper
       Port ( CLK_100           : in  STD_LOGIC;
              ROW               : in  STD_LOGIC_VECTOR (4 downto 0);
              COLUMN            : in  STD_LOGIC_VECTOR (5 downto 0);
              COLOR_8BIT_sig    : in  STD_LOGIC_VECTOR (7 downto 0);
              W_ENABLE          : in  STD_LOGIC;
              R_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
              G_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
              B_OUT             : out STD_LOGIC_VECTOR (3 downto 0);
              HSYNC             : out STD_LOGIC;
              VSYNC             : out STD_LOGIC;
              CLOCK_debug_out   : out STD_LOGIC;
              HSYNC_debug_out   : out STD_LOGIC;
              VSYNC_debug_out   : out STD_LOGIC);
   end component;
   
   component DIGIT_ROM
      port(address  : in std_logic_vector(7 downto 0);
           data     : out std_logic_vector(7 downto 0));
   end component;

   component TIMER
       Port ( CLK       : in STD_LOGIC;
              RST       : in STD_LOGIC;
              PAUSE     : in STD_LOGIC;
              SECONDS   : out STD_LOGIC_VECTOR (7 downto 0);
              MINUTES   : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component NES_CONTROLLER_READER 
       Port ( CLK, RST      : in STD_LOGIC;
              CLK_OUT       : out STD_LOGIC;
              LATCH_OUT     : out STD_LOGIC;
              DATA          : in STD_LOGIC;
              DATA_OUT      : out STD_LOGIC_VECTOR(7 downto 0));
   end component;
   
   component pseudo_random 
       Port ( CLK             : in std_logic;
              PSUEDO_RAND_NUM : out std_logic_vector (7 downto 0)); 
   end component;   
----------------------------------------------------------------------------------------
   
   
   -- Signals for connecting MCU and external modules to RAT_wrapper -------------------
   signal s_input_port                  : std_logic_vector (7 downto 0);
   signal s_output_port                 : std_logic_vector (7 downto 0);
   signal s_port_id, s_NES_DATA_OUT     : std_logic_vector (7 downto 0);
   signal s_load, s_OR_INT, s_SEC_INT   : std_logic;
   signal s_clk_sig                     : std_logic := '0';
   signal r_TXCon                       : std_logic;
   signal r_pause, r_rst                : std_logic;

   
   -- Register definitions for output devices ------------------------------------------
   signal r_LEDS                        : std_logic_vector (7 downto 0);
   signal r_SEVEN_SEG                   : std_logic_vector (7 downto 0);
   signal s_RAND_NUM                    : std_logic_vector (7 downto 0);
   signal r_TXData                      : std_logic_vector (7 downto 0);
   signal r_COLOR                       : std_logic_vector (7 downto 0);
   signal s_sec, s_min                  : std_logic_vector (7 downto 0);
   signal r_COLUMN                      : std_logic_vector (5 downto 0);
   signal r_ROW                         : std_logic_vector (4 downto 0);
   signal r_VGA_EN, s_RST               : std_logic;
   
   -------------------------------------------------------------------------------------

   begin       
        -- Clock Divider Process: slows down clock to 50 MHz ---------------------------
        clkdiv: process(CLK)
        begin
            if RISING_EDGE(CLK) then
                s_clk_sig <= NOT s_clk_sig;
            end if;
        end process clkdiv;  
        --------------------------------------------------------------------------------
       
       
        -- Instantiate components ------------------------------------------------------
        CPU: RAT_MCU
        port map( IN_PORT => s_input_port, OUT_PORT => s_output_port, PORT_ID => s_port_id,
                  RESET => RST, IO_STRB => s_load, INT_IN => s_OR_INT, CLK => s_clk_sig);
        
        SEVEN_SEG: SEVEN_SEG_DRIVER
        port map( HEX_INPUT => r_SEVEN_SEG, CLK => CLK, RST => RST, ANODE => SEVEN_SEG_ANODE, 
                  CATHODE => SEVEN_SEG_CATHODE);
                  
        UART: UART_TX_CTRL 
        port map (SEND => r_TXCon, DATA => r_TXData, CLK => CLK, UART_TX => UART_TX);
        
        INT_SEC:  INT_HANDLER  
        port map ( TIMER_INPUT => s_sec, CLK => CLK, INT_OUT => s_OR_INT);
         
        VGA_DRIVE: static_VGA_wrapper 
        port map ( CLK_100 => CLK, ROW => r_ROW, COLUMN => r_COLUMN, COLOR_8BIT_sig => r_COLOR, 
                   W_ENABLE => r_VGA_EN, R_OUT => R_OUT, G_OUT => G_OUT, B_OUT => B_OUT, 
                   HSYNC => HSYNC, VSYNC => VSYNC);
                   
        Timer_CLK: TIMER 
        port map ( CLK => CLK,RST => s_RST, PAUSE => r_pause, SECONDS => s_sec, MINUTES => s_min);
        
        NES_CONTROLLER  : NES_CONTROLLER_READER 
        port map (CLK => CLK, RST => RST, CLK_OUT => CLK_OUT, LATCH_OUT => LATCH_OUT, 
                  DATA => BUTTON_PRESS, DATA_OUT => s_NES_DATA_OUT);
        
        R_NUMBER: pseudo_random 
        port map (CLK => CLK, PSUEDO_RAND_NUM => s_RAND_NUM);
        -------------------------------------------------------------------------------
    
    
        -------------------------------------------------------------------------------
        -- MUX that selects which input to read into MCU ------------------------------
        -------------------------------------------------------------------------------
        inputs: process(s_port_id, SWITCHES, s_NES_DATA_OUT)
        begin 
            if (s_port_id = SWITCHES_ID) then
                s_input_port <= SWITCHES;
            elsif (s_port_id = SECOND_ID) then
                s_input_port <= s_sec;
            elsif (s_port_id = MINUTE_ID) then
                s_input_port <= s_min;
            elsif (s_port_id = NES_DATA_OUT) then
                s_input_port <= s_NES_DATA_OUT;
            elsif (s_port_id = RAND_NUM) then
                s_input_port <= s_RAND_NUM;
            else
                s_input_port <= x"00";
            end if;
        end process inputs;
        -------------------------------------------------------------------------------
    
    
        -------------------------------------------------------------------------------
        -- MUX for updating output registers ------------------------------------------
        -- Register updates depend on rising clock edge and asserted load signal
        -- add conditions and connections for any added PORT IDs
        -------------------------------------------------------------------------------
        outputs: process(CLK)
        begin
            if (rising_edge(CLK)) then
                if (s_load = '1') then
                    -- the register definition for the LEDS
                    if (s_port_id = LEDS_ID) then
                        r_LEDS <= s_output_port;
                    elsif (s_port_id = SEVEN_ID) then
                        r_SEVEN_SEG <= s_output_port;
                    elsif (s_port_id = TX_CON) then
                        r_TXCon <= s_output_port(0);
                    elsif (s_port_id = TX_DATA) then
                        r_TXData <= s_output_port;
                    elsif (s_port_id = VGA_COLOR) then
                        r_COLOR <= s_output_port;
                    elsif (s_port_id = VGA_COLUMN) then
                        r_COLUMN <= s_output_port(5 downto 0);
                    elsif (s_port_id = VGA_ROW) then
                        r_ROW <= s_output_port(4 downto 0);
                    elsif (s_port_id = VGA_EN) then
                        r_VGA_EN <= s_output_port(0);
                    elsif (s_port_id = TIMER_CON) then
                        r_pause <= s_output_port(0);
                        r_rst   <= s_output_port(1);
                    end if;                   
                end if;
            end if;
        end process outputs;
        -------------------------------------------------------------------------------

        s_RST <= r_rst or RST;
        LEDS  <= r_LEDS;

end Behavioral;