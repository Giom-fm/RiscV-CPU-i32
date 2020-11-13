library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity sign_extender is
    port(                   
        i_mode : in std_logic_vector(2 downto 0);
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0)
    );
end sign_extender;


architecture a_sign_extender of sign_extender is

    constant SIGN_EXTENDER_32 	: std_logic_vector(2 downto 0) := "000";
	constant SIGN_EXTENDER_U_8  : std_logic_vector(2 downto 0) := "001";
    constant SIGN_EXTENDER_U_16 : std_logic_vector(2 downto 0) := "010";
    constant SIGN_EXTENDER_S_8  : std_logic_vector(2 downto 0) := "100";
    constant SIGN_EXTENDER_S_16 : std_logic_vector(2 downto 0) := "101";

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