library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;


entity clock_prescaler is 
		port(
            i_clk : in std_logic;
            o_clk : out std_logic
        );
end clock_prescaler;

architecture a_clock_prescaler of clock_prescaler is
    --constant max : integer := 12000000;
    constant max : integer := 6000000;
    signal counter : integer := 0;
    signal tmp_out : std_logic;
begin
    o_clk <= tmp_out;
    process(i_clk) begin
        if (rising_edge(i_clk)) then
            if counter = max then
                counter <= 0;
                tmp_out <= not tmp_out;
            else
                counter <= counter + 1;
            end if;
        end if;
	end process;	
end a_clock_prescaler;
