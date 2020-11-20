library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.all;


entity alu_mux is 
		port(
        i_mode	    : in T_WRITE_REG_MUX;
        i_reg	    : in std_logic_vector(31 downto 0);
        i_offset	: in std_logic_vector(31 downto 0);
		o_data      : out std_logic_vector(31 downto 0)
		);
		
end alu_mux;

architecture a_alu_mux of alu_mux is

begin
    process(i_mode, i_reg, i_offset) begin
        case i_mode is
            when WRITE_REG_MEM => o_data <= i_offset;
            when others => o_data <= i_reg;
        end case;
    end process;
end architecture;