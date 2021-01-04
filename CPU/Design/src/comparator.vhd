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
	compare : process(i_comparator_mode, i_left, i_right) begin
		
		o_pc_mode <= PC_SRC_ADD;

        case i_comparator_mode is
			when COMP_EQUAL =>
				if unsigned(i_left) = unsigned(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_NOT_EQUAL =>
				if unsigned(i_left) /= unsigned(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_LESS_THEN	=>
				if signed(i_left) < signed(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_GREATER_EQUAL =>	      
				if signed(i_left) >= signed(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_LESS_THEN_U =>	      
				if unsigned(i_left) < unsigned(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when COMP_GREATER_EQUAL_U =>
				if unsigned(i_left) >= unsigned(i_right) then
					o_pc_mode <= PC_SRC_ALU;
				end if;
			when others => null;
        end case;	
	end process;	
end a_comparator;

