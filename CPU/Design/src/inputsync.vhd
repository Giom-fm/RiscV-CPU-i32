library ieee;
use ieee.std_logic_1164.all;

entity InputSynchronisation is
    port(
        clk_i : in std_logic;
        rst_i : in std_logic;
        
        asyncInput : in std_logic;
        syncOutput : out std_logic
    );
end entity;

architecture aInputSynchronisation of InputSynchronisation is
begin
    change_state : process(rst_i, clk_i)
        variable tmp : std_logic;
    begin
        if (rst_i = '1') then 
            syncOutput <= '0'; 
        elsif rising_edge(clk_i) then
           syncOutput <= tmp;
        end if;
    
        if (rst_i = '1') then 
            tmp := '0'; 
        elsif rising_edge(clk_i) then
           tmp := asyncInput;
        end if;
        
    end process;
end architecture;