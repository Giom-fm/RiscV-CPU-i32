library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.types.ALL;


entity mux_register is 
		port(
        i_mode  : in T_MUX_REG;
        i_mem   : in std_logic_vector(31 downto 0);
        i_pc   : in std_logic_vector(31 downto 0);
        i_alu   : in std_logic_vector(31 downto 0);
		o_data  : out std_logic_vector(31 downto 0)
		);
		
end mux_register;

architecture a_mux_register of mux_register is

begin
    process(i_mode, i_alu, i_mem, i_pc) begin
        case i_mode is
            when MUX_REG_ALU    => o_data <= i_alu;
            when MUX_REG_MEM    => o_data <= i_mem;
            when MUX_REG_PC     => o_data <= i_pc;
            when MUX_REG_ZERO   => o_data <= (others => '0');
        end case;
    end process;
end architecture;