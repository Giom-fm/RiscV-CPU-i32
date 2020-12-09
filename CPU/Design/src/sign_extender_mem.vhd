library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;


entity sign_extender_mem is
    port(                   
        i_mode : in T_SEXT_MEM_MODE;
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0)
    );
end sign_extender_mem;


architecture a_sign_extender_mem of sign_extender_mem is
    begin
        process (i_mode, i_data) begin
            case i_mode is
                when SEXT_MEM_U_8   => o_data <= fill_w_zeros(i_data(7 downto 0));
                when SEXT_MEM_U_16  => o_data <= fill_w_zeros(i_data(15 downto 0));
                when SEXT_MEM_S_8   => o_data <= sext(7, i_data);
                when SEXT_MEM_S_16  => o_data <= sext(15, i_data);
                when others => o_data <= i_data;
            end case;
        end process;
end a_sign_extender_mem;