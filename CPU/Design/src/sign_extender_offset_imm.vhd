library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;


entity sign_extender_offset_imm is
    port(                   
        i_mode : in T_SEXT_OFFSET_IMM_MODE;
        i_data : in std_logic_vector(31 downto 0);
        o_data : out std_logic_vector(31 downto 0)
    );
end sign_extender_offset_imm;


architecture a_sign_extender_offset_imm of sign_extender_offset_imm is
    begin
        process (i_mode, i_data) begin
            case i_mode is
                when SEXT_OFFSET_IMM_12  =>
                    o_data <= sext(12, i_data);
                when SEXT_OFFSET_IMM_20  =>
                    o_data <= sext(20, i_data);
            end case;
        end process;
end a_sign_extender_offset_imm;