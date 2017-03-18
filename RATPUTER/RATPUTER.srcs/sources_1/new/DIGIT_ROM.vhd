library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity DIGIT_ROM is
    port(ADDRESS: in std_logic_vector(7 downto 0);
         DATA: out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of DIGIT_ROM is
    type rom_array is array (0 to 255) of std_logic_vector (7 downto 0);
    CONSTANT rom: rom_array := 
     --0------------------------------------------------------------------------------------
    (x"00", x"02", x"FF", x"00", x"00", x"02", x"00", x"FF", x"00", x"00", x"02",        --0
     x"00", x"FF", x"00", x"00", x"02", x"00", x"FF", x"00", x"02", x"FE",
     --21-----------------------------------------------------------------------------------
     x"00", x"01", x"FF", x"01", x"00", x"FF", x"01", x"00", x"FF", x"01", x"00", x"FF", --1
     x"00", x"02", x"FE",
     --36-----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"02", x"00", x"FF", x"00", x"02", x"FF", x"00", x"00", x"FF", --2
     x"00", x"02", x"FE",
     --51-----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"02", x"00", x"FF", x"00", x"02", x"FF", x"02", x"00", x"FF", --3
     x"00", x"02", x"FE",
     --66-----------------------------------------------------------------------------------
     x"00", x"00", x"02", x"00", x"FF", x"00", x"00", x"02", x"00", x"FF", x"00", x"02", --4
     x"FF", x"02", x"00", x"FF", x"02", x"00", x"FE",
     --85-----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"00", x"00", x"FF", x"00", x"02", x"FF", x"02", x"00", x"FF", --5
     x"00", x"02", x"FE",         
     --100----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"00", x"00", x"FF", x"00", x"02", x"FF", x"00", x"00", x"02", --6 
     x"00", x"FF", x"00", x"02", x"FE",  
     --117----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"02", x"00", x"FF", x"02", x"00", x"FF", x"02", x"00", x"FF", --7 
     x"02", x"00", x"FE",
     --132----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"00", x"00", x"02", x"00", x"FF", x"00", x"02", x"FF", x"00", --8
     x"00", x"02", x"00", x"FF", x"00", x"02", x"FE",
     --151----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"00", x"00", x"02", x"00", x"FF", x"00", x"02", x"FF", x"02", --9
     x"00", x"FF", x"02", x"00", x"FE", 
     --168----------------------------------------------------------------------------------
     x"00", x"02", x"FF", x"00", x"02", x"FF",x"00", x"02", x"FF",x"00", x"02", x"FF",
     x"00", x"02", x"FE", others => x"00"); 
begin
    DATA <= rom(to_integer(unsigned(ADDRESS)));
end architecture;