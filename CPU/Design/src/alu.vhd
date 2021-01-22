library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;


entity alu is 
		port(
            i_alu_mode  : in T_ALU_MODE;
            -- RS1
            i_left      : in std_logic_vector(31 downto 0);
            -- RS2
            i_right     : in std_logic_vector(31 downto 0);
            o_result    : out std_logic_vector(31 downto 0)
            
        );
end alu;

architecture a_alu of alu is
    signal res_add : std_logic_vector(31 downto 0);
begin
    calculation : process(i_alu_mode, i_left, i_right, res_add)
    begin
        res_add <= std_logic_vector(unsigned(i_left) + unsigned(i_right));
        case i_alu_mode is
            when ALU_ADD  => o_result <= res_add;
            when ALU_ADD_EVEN  => o_result <= res_add(31 downto 1) & '0';
            when ALU_SUB  => o_result <= std_logic_vector(unsigned(i_left) - unsigned(i_right));
            when ALU_SLL  => o_result <= std_logic_vector(shift_left(unsigned(i_left), to_integer(unsigned(i_right(4 downto 0)))));
            when ALU_SRL  => o_result <= std_logic_vector(shift_right(unsigned(i_left), to_integer(unsigned(i_right(4 downto 0)))));
            when ALU_SRA  => o_result <= std_logic_vector(shift_right(signed(i_left), to_integer(signed(i_right(4 downto 0)))));
            when ALU_SLT  => o_result <= bool_to_word(signed(i_left) < signed(i_right));
            when ALU_SLTU => o_result <= bool_to_word(unsigned(i_left) < unsigned(i_right));
            when ALU_XOR  => o_result <= i_left xor i_right;
            when ALU_OR   => o_result <= i_left or i_right;
            when ALU_AND  => o_result <= i_left and i_right;
            when others   => o_result <= (others => '0');
        end case;	
	end process;	
end a_alu;
