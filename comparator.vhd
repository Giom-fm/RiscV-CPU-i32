library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;


entity comparator is 
		port(
            i_comparator_mode  : in T_COMP_MODE;
            -- RS1
            i_left      : in std_logic_vector(31 downto 0);
            -- RS2
            i_right     : in std_logic_vector(31 downto 0);
            o_pc_mode    : out T_PC_SRC
            
        );
end comparator;

architecture a_comparator of comparator is
	
begin
	compare : process(i_comparator_mode, i_left, i_right)
		variable left_u  : unsigned(31 downto 0) := unsigned(i_left);
		variable right_u : unsigned(31 downto 0) := unsigned(i_right);
		variable left_s  : signed(31 downto 0) := signed(i_left);
		variable right_s : signed(31 downto 0) := signed(i_right);
		begin

        case i_comparator_mode is
			when COMP_EQUAL =>
				if left_u = right_u then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_NOT_EQUAL =>
				if left_u /= right_u then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_LESS_THEN	=>
				if left_s < right_s then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_GREATER_EQUAL =>	      
				if left_s >= right_s then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_LESS_THEN_U =>	      
				if left_u < right_u then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_GREATER_EQUAL_U =>
				if left_u >= right_u then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when others => o_pc_mode <= PC_SRC_ADD;
        end case;	
	end process;	
end a_comparator;

