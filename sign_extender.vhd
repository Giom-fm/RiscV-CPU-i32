library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity sign_extender is
    port(                   
        i_mode : in T_SIGN_EXTENDER_MODE;
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0)
    );
end sign_extender;


architecture a_sign_extender of sign_extender is
    begin
        process (i_mode) begin
            case i_mode is
                when SIGN_EXTENDER_U_8  => o_data <= "000000000000000000000000" & i_data(7 downto 0);
                when SIGN_EXTENDER_U_16 => o_data <= i_data and "0000000000000000" & i_data(15 downto 0);
                when SIGN_EXTENDER_S_8  =>
                    if i_data(7) = '0' then
                        o_data <= "000000000000000000000000" & i_data(7 downto 0);
                        else
                        o_data <= "111111111111111111111111" & i_data(7 downto 0);
                    end if;
                when SIGN_EXTENDER_S_16  =>
                    if i_data(15) = '0' then
                        o_data <= "0000000000000000" & i_data(15 downto 0);
                        else
                        o_data <= "1111111111111111" & i_data(15 downto 0);
                    end if;
                when others => o_data <= i_data;
            end case;
            
        end process;
end a_sign_extender;