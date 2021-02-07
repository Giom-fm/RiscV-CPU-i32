library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_pc is
end entity;

architecture a_test_pc of test_pc is
    constant C_DELAY : time := 10 ps;

    signal clock      : std_logic;
    signal reset      : std_logic;
    signal mode       : T_PC_MODE;
    signal comp     : std_logic;
    signal src_alu    : std_logic_vector(31 downto 0);
    signal src_next   : std_logic_vector(31 downto 0);
    signal t_current  : std_logic_vector(31 downto 0);
    signal t_next     : std_logic_vector(31 downto 0);
    
begin

    pc_test : entity work.pc(a_pc) port map (
        i_clock 	=> clock,
        i_reset 	=> reset,
        i_mode  	=> mode,
        i_comp      => comp,
        i_src_alu   => src_alu,
        i_src_next  => src_next,
        o_current   => t_current,
        o_next      => t_next
        );
    
    test : process
    begin
        
        -- Init Test
        reset <= '1';
        mode <= PC_SRC_ADD;
        comp <= '0';
        clock       <= '0';
        src_alu     <= to_stdlogicvector(x"FFFFFFF0");
        src_next    <= to_stdlogicvector(x"00000004");

        wait for C_DELAY;
        reset <= '0';
        
        -- Test: PC_SRC_ADD
        compare_assert(t_current, to_stdlogicvector(x"00000000"), "Init_current PC_SRC_ADD", C_DELAY);
        compare_assert(t_next, to_stdlogicvector(x"00000004"), "Init_next PC_SRC_ADD", C_DELAY);

        clock <= '1';
        wait for C_DELAY;
        clock <= '0';

        compare_assert(t_current, to_stdlogicvector(x"00000004"), "ADD_current PC_SRC_ADD", C_DELAY);
        compare_assert(t_next, to_stdlogicvector(x"00000008"), "ALU_next PC_SRC_ADD", C_DELAY);

        -- Test: PC_SRC_ALU
        mode <= PC_SRC_ALU;
        compare_assert(t_current, to_stdlogicvector(x"00000004"), "ADD_current PC_SRC_ALU", C_DELAY);

        clock <= '1';
        wait for C_DELAY;
        clock <= '0';

        compare_assert(t_current, to_stdlogicvector(x"FFFFFFF0"), "ALU_current PC_SRC_ALU", C_DELAY);
        compare_assert(t_next,  to_stdlogicvector(x"FFFFFFF4"), "ALU_next PC_SRC_ALU", C_DELAY);

        ---- Test: reset
        --reset <= '1';
        --compare_assert(t_current, "00000000000000000000000000000000", "reset_current", C_DELAY);

        wait;
    end process;


end a_test_pc;