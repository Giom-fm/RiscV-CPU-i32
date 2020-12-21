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
    signal mode       : T_PC_SRC;
    signal src_alu    : std_logic_vector(31 downto 0);
    signal src_next   : std_logic_vector(31 downto 0);
    signal t_current  : std_logic_vector(31 downto 0);
    signal t_next     : std_logic_vector(31 downto 0);
    
    function to_pc(base: std_logic_vector(31 downto 0); step_width: integer) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(step_width, 32) + unsigned(base));
    end;

begin

    pc_test : entity work.pc(a_pc) port map (
        i_clock 	=> clock,
        i_reset 	=> reset,
        i_mode  	=> mode,
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
        clock       <= '0';
        src_alu     <= "11111111111111111111111111111111";
        src_next    <= "00000000000000000000000000000001";

        wait for C_DELAY;
        reset <= '0';
        
        -- Test: PC_SRC_ADD
        compare_assert(t_current, "00000000000000000000000000000000", "Init_current PC_SRC_ADD", C_DELAY);
        compare_assert(t_next, to_pc("00000000000000000000000000000000", PC_ADD), "Init_next PC_SRC_ADD", C_DELAY);

        clock <= '1';
        wait for C_DELAY;
        clock <= '0';

        compare_assert(t_current, "00000000000000000000000000000001", "ADD_current PC_SRC_ADD", C_DELAY);
        compare_assert(t_next, to_pc("00000000000000000000000000000001", PC_ADD), "ALU_next PC_SRC_ADD", C_DELAY);

        -- Test: PC_SRC_ALU
        mode <= PC_SRC_ALU;
        compare_assert(t_current, "00000000000000000000000000000001", "ADD_current PC_SRC_ALU", C_DELAY);

        clock <= '1';
        wait for C_DELAY;
        clock <= '0';

        compare_assert(t_current, "11111111111111111111111111111111", "ALU_current PC_SRC_ALU", C_DELAY);
        compare_assert(t_next, to_pc("11111111111111111111111111111111", PC_ADD), "ALU_next PC_SRC_ALU", C_DELAY);

        -- Test: reset
        reset <= '1';
        compare_assert(t_current, "00000000000000000000000000000000", "reset_current", C_DELAY);

        wait;
    end process;


end a_test_pc;