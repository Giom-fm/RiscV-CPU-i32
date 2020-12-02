library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity store_coding is
    port(                   
        i_mode      : in T_STORE_MODE;
        i_data_old  : in std_logic_vector(31 downto 0);
        i_data_new  : in std_logic_vector(31 downto 0);
        o_data      : out std_logic_vector(31 downto 0)
    );
end store_coding;


architecture a_store_coding of store_coding is
    begin
        process (i_mode, i_data_new, i_data_old) begin
            case i_mode is 
            when STORE_B => o_data <= i_data_old(31 downto 8) & i_data_new(7 downto 0); 
            when STORE_H => o_data <= i_data_old(31 downto 16) & i_data_new(15 downto 0);
            when STORE_W => o_data <= i_data_new;
            when others => o_data <= i_data_old;
            end case;
            
        end process;
end a_store_coding;