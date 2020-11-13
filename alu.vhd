library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity alu is 
		port(
			i_alu_mode  : in T_ALU_MODE;
            i_left      : in std_logic_vector(31 downto 0);
            i_right     : in std_logic_vector(31 downto 0);
            o_result    : out std_logic_vector(31 downto 0)
            
        );
end alu;

architecture a_alu of alu is    
begin
    calculation : process(i_alu_mode, i_left, i_right) begin
        case i_alu_mode is
            when ALU_AND =>
                o_result <= i_left and i_right;
            when ALU_OR =>
                o_result <= i_left or i_right;
            when ALU_XOR =>
                o_result <= i_left xor i_right;
            when ALU_ADD =>
                o_result <= std_logic_vector(unsigned(i_left) + unsigned(i_right));
            when ALU_SUB =>
                o_result <= std_logic_vector(unsigned(i_left) - unsigned(i_right));
            when others => 
                o_result <= (others => '0');
        end case;	
	end process;	
end a_alu;
