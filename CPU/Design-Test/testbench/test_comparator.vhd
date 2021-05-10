-- Tests for comparator
-- Author : Guillaume Fournier-Mayer (tinf101922)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_comparator is
end entity;

architecture a_test_comparator of test_comparator is
    constant C_DELAY : time := 10 ps;

    signal comparator_mode  : T_COMP_MODE;
    signal left             : std_logic_vector(31 downto 0);
    signal right            : std_logic_vector(31 downto 0);
    signal result           : std_logic;

begin

    comparator_test : entity work.comparator(a_comparator) port map (
        i_comparator_mode   => comparator_mode,
        i_left              => left,
        i_right             => right,
        o_result            => result
        );
    
    test : process
    begin

        -- Test: COMP_EQUAL
        comparator_mode <= COMP_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010101";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_EQUAL");
        wait for C_DELAY;

        comparator_mode <= COMP_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010100";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_EQUAL");
        wait for C_DELAY;

        -- Test: COMP_NOT_EQUAL
        comparator_mode <= COMP_NOT_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010101";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_NOT_EQUAL");
        wait for C_DELAY;

        comparator_mode <= COMP_NOT_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010100";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_NOT_EQUAL");
        wait for C_DELAY;

        -- Test: COMP_LESS_THEN
        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_LESS_THEN");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_LESS_THEN");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_LESS_THEN");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_LESS_THEN");
        wait for C_DELAY;

        -- Test: COMP_GREATER_EQUAL
        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_GREATER_EQUAL");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_GREATER_EQUAL");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_GREATER_EQUAL");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_GREATER_EQUAL");
        wait for C_DELAY;

        -- Test: COMP_LESS_THEN_U
        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_LESS_THEN_U");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_LESS_THEN_U");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_LESS_THEN_U");
        wait for C_DELAY;

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_LESS_THEN_U");
        wait for C_DELAY;

        -- Test: COMP_GREATER_EQUAL_U
        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        wait for C_DELAY;
        compare_assert_bool(result, '0', "COMP_GREATER_EQUAL_U");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_GREATER_EQUAL_U");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_GREATER_EQUAL_U");
        wait for C_DELAY;

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        wait for C_DELAY;
        compare_assert_bool(result, '1', "COMP_GREATER_EQUAL_U");
        wait for C_DELAY;

        wait;
    end process;


end a_test_comparator;