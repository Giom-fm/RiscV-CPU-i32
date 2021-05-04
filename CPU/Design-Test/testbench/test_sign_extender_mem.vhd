-- Tests for sign extender
-- Author : Guillaume Fournier-Mayer (tinf101922)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_sign_extender_mem is
end entity;

architecture a_test_sign_extender_mem of test_sign_extender_mem is
    constant C_DELAY  : time := 10 ps;

    signal mode     : T_SEXT_MEM_MODE;
    signal i_data   : std_logic_vector(31 downto 0);
    signal data     : std_logic_vector(31 downto 0);
        
begin

    sign_extender_mem_test : entity work.sign_extender_mem(a_sign_extender_mem) port map (
        i_mode  => mode,
        i_data   => i_data,
        o_data  => data
        );
    
    test : process
    begin

        -- Test: SEXT_MEM_S_8, 
        mode    <= SEXT_MEM_S_8;
        i_data  <= "00000000000000000000000000000000";
        compare_assert(data, "00000000000000000000000000000000", "SEXT_MEM_S_8", C_DELAY);

        mode    <= SEXT_MEM_S_8;
        i_data  <= "00000000000000000000000000001111";
        compare_assert(data, "00000000000000000000000000001111", "SEXT_MEM_S_8", C_DELAY);

        mode    <= SEXT_MEM_S_8;
        i_data  <= "00000000000000000000000011111111";
        compare_assert(data, "11111111111111111111111111111111", "SEXT_MEM_S_8", C_DELAY);

        mode    <= SEXT_MEM_S_8;
        i_data  <= "00000000000000000000111111111111";
        compare_assert(data, "11111111111111111111111111111111", "SEXT_MEM_S_8", C_DELAY);

        mode    <= SEXT_MEM_S_8;
        i_data  <= "11110000000000000000000010000000";
        compare_assert(data, "11111111111111111111111110000000", "SEXT_MEM_S_8", C_DELAY);

        mode    <= SEXT_MEM_S_8;
        i_data  <= "10000000000000000000000000000001";
        compare_assert(data, "00000000000000000000000000000001", "SEXT_MEM_S_8", C_DELAY);

        -- Test: SEXT_MEM_U_8
        mode    <= SEXT_MEM_U_8;
        i_data  <= "00000000000000000000000000000000";
        compare_assert(data, "00000000000000000000000000000000", "SEXT_MEM_U_8", C_DELAY);

        mode    <= SEXT_MEM_U_8;
        i_data  <= "00000000000000000000000000001111";
        compare_assert(data, "00000000000000000000000000001111", "SEXT_MEM_U_8", C_DELAY);

        mode    <= SEXT_MEM_U_8;
        i_data  <= "00000000000000000000000011111111";
        compare_assert(data, "00000000000000000000000011111111", "SEXT_MEM_U_8", C_DELAY);

        mode    <= SEXT_MEM_U_8;
        i_data  <= "00000000000000000000111111111111";
        compare_assert(data, "00000000000000000000000011111111", "SEXT_MEM_U_8", C_DELAY);

        mode    <= SEXT_MEM_U_8;
        i_data  <= "11110000000000000000000010000000";
        compare_assert(data, "00000000000000000000000010000000", "SEXT_MEM_U_8", C_DELAY);

        mode    <= SEXT_MEM_U_8;
        i_data  <= "10000000000000000000000000000001";
        compare_assert(data, "00000000000000000000000000000001", "SEXT_MEM_U_8", C_DELAY);

        -- Test: SEXT_MEM_S_16
        mode    <= SEXT_MEM_S_16;
        i_data  <= "00000000000000000000000000000000";
        compare_assert(data, "00000000000000000000000000000000", "SEXT_MEM_S_16", C_DELAY);

        mode    <= SEXT_MEM_S_16;
        i_data  <= "00000000000000000000111111111111";
        compare_assert(data, "00000000000000000000111111111111", "SEXT_MEM_S_16", C_DELAY);

        mode    <= SEXT_MEM_S_16;
        i_data  <= "00000000000000001111111111111111";
        compare_assert(data, "11111111111111111111111111111111", "SEXT_MEM_S_16", C_DELAY);

        mode    <= SEXT_MEM_S_16;
        i_data  <= "00000000000011111111111111111111";
        compare_assert(data, "11111111111111111111111111111111", "SEXT_MEM_S_16", C_DELAY);

        mode    <= SEXT_MEM_S_16;
        i_data  <= "11110000000000001000000000000000";
        compare_assert(data, "11111111111111111000000000000000", "SEXT_MEM_S_16", C_DELAY);

        mode    <= SEXT_MEM_S_16;
        i_data  <= "10000000000000000000000000000001";
        compare_assert(data, "00000000000000000000000000000001", "SEXT_MEM_S_16", C_DELAY);

        -- Test: SEXT_MEM_U_16
        mode    <= SEXT_MEM_U_16;
        i_data  <= "00000000000000000000000000000000";
        compare_assert(data, "00000000000000000000000000000000", "SEXT_MEM_U_16", C_DELAY);

        mode    <= SEXT_MEM_U_16;
        i_data  <= "00000000000000000000111111111111";
        compare_assert(data, "00000000000000000000111111111111", "SEXT_MEM_U_16", C_DELAY);

        mode    <= SEXT_MEM_U_16;
        i_data  <= "00000000000000001111111111111111";
        compare_assert(data, "00000000000000001111111111111111", "SEXT_MEM_U_16", C_DELAY);

        mode    <= SEXT_MEM_U_16;
        i_data  <= "00000000000011111111111111111111";
        compare_assert(data, "00000000000000001111111111111111", "SEXT_MEM_U_16", C_DELAY);

        mode    <= SEXT_MEM_U_16;
        i_data  <= "11110000000000001000000000000000";
        compare_assert(data, "00000000000000001000000000000000", "SEXT_MEM_U_16", C_DELAY);

        mode    <= SEXT_MEM_U_16;
        i_data  <= "10000000000000000000000000000001";
        compare_assert(data, "00000000000000000000000000000001", "SEXT_MEM_U_16", C_DELAY);
        
        -- Test: SEXT_MEM_32
        mode    <= SEXT_MEM_32;
        i_data  <= "00000000000000000000000000000000";
        compare_assert(data, "00000000000000000000000000000000", "SEXT_MEM_32", C_DELAY);

        mode    <= SEXT_MEM_32;
        i_data  <= "11110000000000000000000010000000";
        compare_assert(data, "11110000000000000000000010000000", "SEXT_MEM_32", C_DELAY);

        mode    <= SEXT_MEM_32;
        i_data  <= "11110000000000001000000000000000";
        compare_assert(data, "11110000000000001000000000000000", "SEXT_MEM_32", C_DELAY);

        mode    <= SEXT_MEM_32;
        i_data  <= "10000000000000000000000000000001";
        compare_assert(data, "10000000000000000000000000000001", "SEXT_MEM_32", C_DELAY);

        wait;
    end process;


end a_test_sign_extender_mem;