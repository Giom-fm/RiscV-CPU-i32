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
            o_result    : out std_logic
        );
end comparator;

architecture a_comparator of comparator is
	
begin
	compare : process(i_comparator_mode, i_left, i_right) begin
		
		o_result <= '0';

        case i_comparator_mode is
			when COMP_EQUAL =>
				if unsigned(i_left) = unsigned(i_right) then
					o_result <= '1';
				end if;
			when COMP_NOT_EQUAL =>
				if unsigned(i_left) /= unsigned(i_right) then
					o_result <= '1';
				end if;
			when COMP_LESS_THEN	=>
				if signed(i_left) < signed(i_right) then
					o_result <= '1';
				end if;
			when COMP_GREATER_EQUAL =>	      
				if signed(i_left) >= signed(i_right) then
					o_result <= '1';
				end if;
			when COMP_LESS_THEN_U =>	      
				if unsigned(i_left) < unsigned(i_right) then
					o_result <= '1';
				end if;
			when COMP_GREATER_EQUAL_U =>
				if unsigned(i_left) >= unsigned(i_right) then
					o_result <= '1';
				end if;
        end case;	
	end process;	
end a_comparator;

