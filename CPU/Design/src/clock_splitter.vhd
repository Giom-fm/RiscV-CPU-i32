library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;


entity clock_splitter is 
		port(
            i_clk : in std_logic;
            o_clk : out std_logic;
            o_clk_div_2 : out std_logic
        );
end clock_splitter;

architecture a_clock_splitter of clock_splitter is
    signal counter : std_logic := '1';
begin
    o_clk <= i_clk;
    o_clk_div_2 <= counter;
    process(i_clk) begin
        if (rising_edge(i_clk)) then
            counter <= not counter;
        end if;
	end process;	
end a_clock_splitter;
