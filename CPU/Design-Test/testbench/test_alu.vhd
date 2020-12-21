library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_alu is
end entity;

architecture a_test_alu of test_alu is
    constant C_DELAY  : time := 10 ps;

    signal alu_mode : T_ALU_MODE;
    signal left     : std_logic_vector(31 downto 0);
    signal right    : std_logic_vector(31 downto 0);
    signal result   : std_logic_vector(31 downto 0);

begin
    alu_test : entity work.alu(a_alu) port map (
        i_alu_mode  => alu_mode,
        i_left      => left,
        i_right     => right,
        o_result    => result
    );

    test : process
    begin

        -- Test: ALU_UNUSED
        alu_mode    <= ALU_UNUSED;
        left        <=  "11111111010101010101010101010110";
        right       <=  "10101010101010101010101011111111";
        compare_assert(result, "00000000000000000000000000000000", "ALU_UNUSED", C_DELAY);

        -- Test: ADD
        alu_mode <= ALU_ADD;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000010", "ALU_ADD", C_DELAY);

        alu_mode <= ALU_ADD;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000010";
        compare_assert(result, "00000000000000000000000000000001", "ALU_ADD", C_DELAY);

        -- Test: ALU_ADD_EVEN
        alu_mode <= ALU_ADD_EVEN;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000010", "ALU_ADD_EVEN", C_DELAY);

        alu_mode <= ALU_ADD_EVEN;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000000", "ALU_ADD_EVEN", C_DELAY);

        alu_mode <= ALU_ADD_EVEN;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000010";
        compare_assert(result, "00000000000000000000000000000000", "ALU_ADD_EVEN", C_DELAY);

        -- Test: ALU_SUB
        alu_mode <= ALU_SUB;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SUB", C_DELAY);

        alu_mode <= ALU_SUB;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000010";
        compare_assert(result, "11111111111111111111111111111110", "ALU_SUB", C_DELAY);

        -- Test: ALU_SLL
        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SLL", C_DELAY);

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000011";
        compare_assert(result, "00000000000000000000000000001000", "ALU_SLL", C_DELAY);

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000011111";
        compare_assert(result, "10000000000000000000000000000000", "ALU_SLL", C_DELAY);

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000111111";
        compare_assert(result, "10000000000000000000000000000000", "ALU_SLL", C_DELAY);

        -- Test: SRL
        alu_mode <= ALU_SRL;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SRL", C_DELAY);

        alu_mode <= ALU_SRL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SRL", C_DELAY);

        alu_mode <= ALU_SRL;
        left    <= "10000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "01000000000000000000000000000000", "ALU_SRL", C_DELAY);

        alu_mode <= ALU_SRL;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000011111";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SRL", C_DELAY);

        alu_mode <= ALU_SRL;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000111111";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SRL", C_DELAY);

        -- Test: SRA
        alu_mode <= ALU_SRA;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000001", "SRA", C_DELAY);
        
        alu_mode <= ALU_SRA;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000000", "SRA", C_DELAY);
        
        alu_mode <= ALU_SRA;
        left    <= "10000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "11000000000000000000000000000000", "SRA", C_DELAY);

        alu_mode <= ALU_SRA;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000011111";
        compare_assert(result, "11111111111111111111111111111111", "SRA", C_DELAY);

        -- Test: SLT
        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SLT", C_DELAY);

        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SLT", C_DELAY);

        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SLT", C_DELAY);

        alu_mode <= ALU_SLT;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SLT", C_DELAY);

        -- Test: SLTU
        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000001", "ALU_SLTU", C_DELAY);

        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SLTU", C_DELAY);

        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SLTU", C_DELAY);

        alu_mode <= ALU_SLTU;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000000";
        compare_assert(result, "00000000000000000000000000000000", "ALU_SLTU", C_DELAY);

        -- Test: XOR
        alu_mode <= ALU_XOR;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        compare_assert(result, "11111111000000001111111100000000", "ALU_XOR", C_DELAY);

        -- Test: OR
        alu_mode <= ALU_OR;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        compare_assert(result, "11111111111111111111111100000000", "OR", C_DELAY);

        -- Test: AND
        alu_mode <= ALU_AND;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        compare_assert(result, "00000000111111110000000000000000", "AND", C_DELAY);

        wait;
    end process;


end a_test_alu;