-- Tests for left ALU mux
-- Author : Guillaume Fournier-Mayer (tinf101922)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_mux_alu_left is
end entity;

architecture a_test_mux_alu_left of test_mux_alu_left is
    constant C_DELAY  : time := 10 ps;

    signal mode     : T_MUX_ALU;
    signal rs1      : std_logic_vector(31 downto 0);
    signal pc       : std_logic_vector(31 downto 0);
    signal data     : std_logic_vector(31 downto 0);
        
begin

    mux_alu_left_test : entity work.mux_alu_left(a_mux_alu_left) port map (
        i_mode  => mode,
        i_rs1   => rs1,
        i_pc    => pc,
        o_data  => data
        );
    
    test : process
    begin
        
        -- Test: MUX_ALU_RS1_RS2
        mode    <= MUX_ALU_RS1_RS2;
        rs1     <= "00000000000000000000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "00000000000000000000000000000000", "MUX_ALU_RS1_RS2", C_DELAY);

        -- Test: MUX_ALU_RS1_IMM
        mode    <= MUX_ALU_RS1_IMM;
        rs1     <= "00000000000000000000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "00000000000000000000000000000000", "MUX_ALU_RS1_IMM", C_DELAY);

        -- Test: MUX_ALU_PC_IMM
        mode    <= MUX_ALU_PC_IMM;
        rs1     <= "00000000000000000000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "11111111111111111111111111111111", "MUX_ALU_PC_IMM", C_DELAY);

        -- Test: MUX_ALU_PC_RS2
        mode    <= MUX_ALU_PC_RS2;
        rs1     <= "00000000000000000000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "11111111111111111111111111111111", "MUX_ALU_PC_RS2", C_DELAY);

        wait;
    end process;


end a_test_mux_alu_left;