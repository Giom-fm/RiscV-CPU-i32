library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;

package utils is

    function fill_w_zeros(vector: std_logic_vector)
        return std_logic_vector;

    function fill_w_ones(vector: std_logic_vector)
        return std_logic_vector;

    function bool_to_word(bool: boolean)
        return std_logic_vector;
end package utils;
   
package body utils is

    function fill_w_zeros(vector: std_logic_vector) return std_logic_vector is
        variable zeros : std_logic_vector(31 downto vector'length) := (others => '0');
    begin
        return zeros & vector;
    end;

    function fill_w_ones(vector: std_logic_vector) return std_logic_vector is
        variable ones : std_logic_vector(31 downto vector'length) := (others => '1');
    begin
        return ones & vector;
    end;

    function bool_to_word(bool: boolean) return std_logic_vector is
    begin
        if(bool) then
            return fill_w_zeros("1");
        else 
            return fill_w_zeros("0");
        end if;
    end;
 end package body utils;