library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bus_mux is 
		port(
        i_sw	    : in std_logic;
        i_data_0	: in std_logic_vector(31 downto 0);
        i_data_1	: in std_logic_vector(31 downto 0);
				o_data_r    : out std_logic_vector(31 downto 0)
		);
		
end bus_mux;

architecture a_bus_mux of bus_mux is

begin
    process(i_sw) begin
        o_data_r <= i_data_0;

        if i_sw = '1' then
            o_data_r <= i_data_1;
        end if;

    end process;
end architecture;