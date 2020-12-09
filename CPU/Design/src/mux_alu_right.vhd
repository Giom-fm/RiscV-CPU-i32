library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.ALL;

entity mux_alu_right is 
		port(
        i_mode	 : in T_MUX_ALU;
        i_rs2	 : in std_logic_vector(31 downto 0);
        i_imm    : in std_logic_vector(31 downto 0);
		o_data   : out std_logic_vector(31 downto 0)
		);
		
end mux_alu_right;

architecture a_mux_alu_right of mux_alu_right is

begin
    process(i_mode, i_rs2, i_imm) begin
        case i_mode is
            when MUX_ALU_RS1_RS2	=> o_data <= i_rs2;
            when MUX_ALU_RS1_IMM	=> o_data <= i_imm;
            when MUX_ALU_PC_IMM	    => o_data <= i_imm;
            when MUX_ALU_PC_RS2     => o_data <= i_rs2;
        end case;
    end process;
end architecture;