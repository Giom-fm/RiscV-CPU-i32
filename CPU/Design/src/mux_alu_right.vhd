library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.all;


entity mux_alu_right is 
		port(
        i_mode	    : in T_MUX_CONTROL;
        i_rs2	    : in std_logic_vector(31 downto 0);
        i_offset	: in std_logic_vector(31 downto 0);
		o_data      : out std_logic_vector(31 downto 0)
		);
		
end mux_alu_right;

architecture a_mux_alu_right of mux_alu_right is

begin
    process(i_mode, i_rs2, i_offset) begin
        case i_mode is
            when MUX_CONTROL_LOAD | MUX_CONTROL_STORE | MUX_CONTROL_BRANCH | MUX_CONTROL_JUMP_REL | MUX_CONTROL_JUMP_ABS => o_data <= i_offset;
            when others => o_data <= i_rs2;
        end case;
    end process;
end architecture;