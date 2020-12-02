library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.utils.all;


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
        -- ADD
        alu_mode <= ALU_ADD;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000010";
        wait for C_DELAY;

        alu_mode <= ALU_ADD;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        -- SUB
        alu_mode <= ALU_SUB;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SUB;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "11111111111111111111111111111111";
        wait for C_DELAY;

        -- SLL
        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000011";
        wait for C_DELAY;
        assert result = "00000000000000000000000000001000";
        wait for C_DELAY;

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000011111";
        wait for C_DELAY;
        assert result = "10000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SLL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000111111";
        wait for C_DELAY;
        assert result = "10000000000000000000000000000000";
        wait for C_DELAY;

        -- SLT
        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SLT;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SLT;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000000";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        -- SLTU
        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000000";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SLTU;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SLTU;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000000000";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        -- XOR
        alu_mode <= ALU_XOR;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        wait for C_DELAY;
        assert result = "11111111000000001111111100000000";
        wait for C_DELAY;

        -- SRL
        alu_mode <= ALU_SRL;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";

        alu_mode <= ALU_SRL;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SRL;
        left    <= "10000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "01000000000000000000000000000000";
        wait for C_DELAY;

        alu_mode <= ALU_SRL;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000011111";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SRL;
        left    <= "11111111111111111111111111111111";
        right   <= "00000000000000000000000000111111";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        -- SRA
        -- Shift no Sign by one to the right
        alu_mode <= ALU_SRA;
        left    <= "00000000000000000000000000000010";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000001";
        wait for C_DELAY;

        alu_mode <= ALU_SRA;
        left    <= "00000000000000000000000000000001";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "00000000000000000000000000000000";
        wait for C_DELAY;
        
        alu_mode <= ALU_SRA;
        left    <= "10000000000000000000000000000000";
        right   <= "00000000000000000000000000000001";
        wait for C_DELAY;
        assert result = "11000000000000000000000000000000";
        wait for C_DELAY;

        -- OR
        alu_mode <= ALU_OR;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        wait for C_DELAY;
        assert result = "11111111111111111111111100000000";
        wait for C_DELAY;

        -- AND
        alu_mode <= ALU_AND;
        left    <= "11111111111111110000000000000000";
        right   <= "00000000111111111111111100000000";
        wait for C_DELAY;
        assert result = "00000000111111110000000000000000";
        wait for C_DELAY;


        wait;
    end process;


end a_test_alu;