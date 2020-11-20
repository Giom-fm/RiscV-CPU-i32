library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.ALL;


entity write_reg_mux is 
		port(
        i_mode  : in T_WRITE_REG_MUX;
        i_imm   : in std_logic_vector(31 downto 0);
        i_alu   : in std_logic_vector(31 downto 0);
        i_mem   : in std_logic_vector(31 downto 0);
		o_data  : out std_logic_vector(31 downto 0)
		);
		
end write_reg_mux;

architecture a_write_reg_mux of write_reg_mux is

begin
    process(i_mode, i_imm, i_alu, i_mem) begin
        case i_mode is
            when WRITE_REG_ALU => o_data <= i_alu;
            when WRITE_REG_IMM => o_data <= i_imm;
            when WRITE_REG_MEM => o_data <= i_mem;
            when others => o_data <= ZERO_W;
        end case;
    end process;
end architecture;