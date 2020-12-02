library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.ALL;

entity mux_alu_left is 
		port(
        i_mode	    : in T_MUX_CONTROL;
        i_rs1	    : in std_logic_vector(31 downto 0);
        i_pc    	: in std_logic_vector(31 downto 0);
		o_data      : out std_logic_vector(31 downto 0)
		);
		
end mux_alu_left;

architecture a_mux_alu_left of mux_alu_left is

begin
    process(i_mode, i_rs1, i_pc) begin
        case i_mode is
            when MUX_CONTROL_BRANCH => o_data <= i_pc;
            when others => o_data <= i_rs1;
        end case;
    end process;
end architecture;