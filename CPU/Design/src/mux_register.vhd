library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.ALL;


entity mux_register is 
		port(
        i_mode  : in T_MUX_CONTROL;
        i_imm   : in std_logic_vector(31 downto 0);
        i_alu   : in std_logic_vector(31 downto 0);
        i_mem   : in std_logic_vector(31 downto 0);
        i_pc   : in std_logic_vector(31 downto 0);
		o_data  : out std_logic_vector(31 downto 0)
		);
		
end mux_register;

architecture a_mux_register of mux_register is

begin
    process(i_mode, i_imm, i_alu, i_mem, i_pc) begin
        case i_mode is
            when MUX_CONTROL_ALU => o_data <= i_alu;
            when MUX_CONTROL_IMM => o_data <= i_imm;
            when MUX_CONTROL_LOAD => o_data <= i_mem;
            when MUX_CONTROL_BRANCH => o_data <= (others => '0');
            when MUX_CONTROL_JUMP_REL => o_data <= i_pc;
            when MUX_CONTROL_JUMP_ABS => o_data <= i_pc;
            when others => o_data <= (others => '0');
        end case;
    end process;
end architecture;