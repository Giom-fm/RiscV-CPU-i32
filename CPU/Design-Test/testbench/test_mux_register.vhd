library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;
use work.test_utils.all;


entity test_mux_register is
end entity;

architecture a_test_mux_register of test_mux_register is
    constant C_DELAY  : time := 10 ps;

    signal mode     : T_MUX_REG;
    signal alu      : std_logic_vector(31 downto 0);
    signal mem      : std_logic_vector(31 downto 0);
    signal pc       : std_logic_vector(31 downto 0);
    signal data     : std_logic_vector(31 downto 0);
        
begin

    mux_register_test : entity work.mux_register(a_mux_register) port map (
        i_mode  => mode,
        i_alu   => alu,
        i_mem   => mem,
        i_pc   => pc,
        o_data  => data
        );
    
    test : process
    begin

        -- Test: MUX_REG_ALU
        mode    <= MUX_REG_ALU;
        alu     <= "00000000000000001111111111111111";
        mem     <= "11111111111111110000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "00000000000000001111111111111111", "MUX_REG_ALU", C_DELAY);

        -- Test: MUX_REG_MEM
        mode    <= MUX_REG_MEM;
        alu     <= "00000000000000001111111111111111";
        mem     <= "11111111111111110000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "11111111111111110000000000000000", "MUX_REG_MEM", C_DELAY);

        -- Test: MUX_REG_PC
        mode    <= MUX_REG_PC;
        alu     <= "00000000000000001111111111111111";
        mem     <= "11111111111111110000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "11111111111111111111111111111111", "MUX_REG_PC", C_DELAY);

        -- Test: MUX_REG_ZERO
        mode    <= MUX_REG_ZERO;
        alu     <= "00000000000000001111111111111111";
        mem     <= "11111111111111110000000000000000";
        pc      <= "11111111111111111111111111111111";
        compare_assert(data, "00000000000000000000000000000000", "MUX_REG_ZERO", C_DELAY);

        wait;
    end process;


end a_test_mux_register;