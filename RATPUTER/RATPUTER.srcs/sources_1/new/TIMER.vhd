-------------------------------------------------------------------------------------------------------
-- Engineer: Ezzeddeen Gazali and Tyler Starr
-- Description: This module behaves as a timer. The module keeps track of the time and can be paused 
--              and reset.
-------------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TIMER is port ( CLK      : in STD_LOGIC;
                       RST      : in STD_LOGIC;
                       PAUSE    : in STD_LOGIC;
                       SECONDS  : out STD_LOGIC_VECTOR (7 downto 0);    -- bit(7:4) tens, bit(3:0) ones
                       MINUTES  : out STD_LOGIC_VECTOR (7 downto 0));   -- bit(7:4) tens, bit(3:0) ones
end TIMER;

architecture Behavioral of TIMER is
    
    constant max_count : integer := 49999999; 
    signal tmp_clk : std_logic := '0';
     
    begin
    -------------------------------------------------------------------------------------
    --- A clock divider to slow down the Basys 3 Boards clock to a 1 Hz clock.
    --- This will slow down the clock to a clock that pulses once per second
        CLK_1HZ: process (clk,tmp_clk)              
           variable div_cnt : integer := 0;   
        begin
           if (rising_edge(clk)) then   
              if (div_cnt = MAX_COUNT) then 
                 tmp_clk <= not tmp_clk and (not PAUSE); 
                 div_cnt := 0; 
              else
                 div_cnt := div_cnt + 1; 
              end if; 
           end if; 
        end process CLK_1HZ;
      -------------------------------------------------------------------------------------  
        
        
        TIMER:  process (tmp_clk, RST)
            variable tmp_sec, tmp_min : std_logic_vector(7 downto 0) := (others => '0'); 
        
        begin
        -- Clears the timer when reset is asserted. ------------------
            if (RST = '1') then 
                tmp_sec := "00000000";
                tmp_min := "00000000";
            
        -- Update time every second ----------------------------------    
            elsif (rising_edge(tmp_clk)) then
                tmp_sec(3 downto 0) := tmp_sec(3 downto 0) + 1; 
        
        -- Update ones part of the seconds ---------------------------        
                if (tmp_sec(3 downto 0) = "1010") then
                    tmp_sec(3 downto 0) := "0000";
                    tmp_sec(7 downto 4) := tmp_sec(7 downto 4) + 1;
                end if;
        -- Update tens part of the seconds ---------------------------        
                if (tmp_sec(7 downto 4) = "0110") then
                    tmp_sec(7 downto 4) := "0000";
                    tmp_min(3 downto 0) := tmp_min(3 downto 0) + 1;
                end if;
        -- Update ones part of the minutes ---------------------------             
                if (tmp_min(3 downto 0) = "1010") then
                    tmp_min(3 downto 0) := "0000";
                    tmp_min(7 downto 4) := tmp_min(7 downto 4) + 1;
                end if;
        -- Update tens part of the minutes ---------------------------      
                if (tmp_min(7 downto 4) = "0110") then
                    tmp_sec := "00000000";
                    tmp_min := "00000000";
                end if;
            end if; 
            
            SECONDS <= tmp_sec;
            MINUTES <= tmp_min;
            
        end process;
end Behavioral;
