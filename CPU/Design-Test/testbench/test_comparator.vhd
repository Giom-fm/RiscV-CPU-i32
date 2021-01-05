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
    signal result          : std_logic;

begin

    comparator_test : entity work.comparator(a_comparator) port map (
        i_comparator_mode   => comparator_mode,
        i_left              => left,
        i_right             => right,
        o_result           => result
        );
    
    test : process
    begin
        compare_assert('0', '0', "Test1", C_DELAY);
        compare_assert('0', '1', "Test2", C_DELAY);
        compare_assert('1', '0', "Test3", C_DELAY);
        compare_assert('1', '1', "Test4", C_DELAY);


        -- Test: COMP_EQUAL
        comparator_mode <= COMP_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010101";
        compare_assert(result, '1', "COMP_EQUAL", C_DELAY);

        comparator_mode <= COMP_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010100";
        compare_assert(result, '0', "COMP_EQUAL", C_DELAY);

        -- Test: COMP_NOT_EQUAL
        comparator_mode <= COMP_NOT_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010101";
        compare_assert(result, '0', "COMP_NOT_EQUAL", C_DELAY);

        comparator_mode <= COMP_NOT_EQUAL;
        left            <= "01010101010101010101010101010101";
        right           <= "01010101010101010101010101010100";
        compare_assert(result, '1', "COMP_NOT_EQUAL", C_DELAY);

        -- Test: COMP_LESS_THEN
        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        compare_assert(result, '1', "COMP_LESS_THEN", C_DELAY);

        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_LESS_THEN", C_DELAY);

        comparator_mode <= COMP_LESS_THEN;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_LESS_THEN", C_DELAY);

        comparator_mode <= COMP_LESS_THEN;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '1', "COMP_LESS_THEN", C_DELAY);

        -- Test: COMP_GREATER_EQUAL
        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        compare_assert(result, '0', "COMP_GREATER_EQUAL", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_GREATER_EQUAL", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_GREATER_EQUAL", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_GREATER_EQUAL", C_DELAY);

        -- Test: COMP_LESS_THEN_U
        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        compare_assert(result, '1', "COMP_LESS_THEN_U", C_DELAY);

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_LESS_THEN_U", C_DELAY);

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_LESS_THEN_U", C_DELAY);

        comparator_mode <= COMP_LESS_THEN_U;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_LESS_THEN_U", C_DELAY);

        -- Test: COMP_GREATER_EQUAL_U
        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000001";
        compare_assert(result, '0', "COMP_GREATER_EQUAL_U", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000001";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_GREATER_EQUAL_U", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "00000000000000000000000000000000";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '0', "COMP_GREATER_EQUAL_U", C_DELAY);

        comparator_mode <= COMP_GREATER_EQUAL_U;
        left            <= "11111111111111111111111111111111";
        right           <= "00000000000000000000000000000000";
        compare_assert(result, '1', "COMP_GREATER_EQUAL_U", C_DELAY);

        wait;
    end process;


end a_test_comparator;