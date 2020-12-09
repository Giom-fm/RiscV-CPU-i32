library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.types.all;

package utils is

    function extend(data: std_logic_vector; length: integer)
        return std_logic_vector;

    function extend_signed(data: std_logic_vector; length: integer)
        return std_logic_vector;

    function bool_to_word(bool: boolean)
        return std_logic_vector;

end package utils;
   
package body utils is

    function extend(data: std_logic_vector; length: integer) return std_logic_vector is
    begin
        return std_logic_vector(resize(unsigned(data), length));
    end;

    function extend_signed(data: std_logic_vector; length: integer) return std_logic_vector is
    begin
        return std_logic_vector(resize(signed(data), length));
    end;

    function bool_to_word(bool: boolean) return std_logic_vector is
    begin
        if(bool) then
            return extend("1", 32);
        else 
            return extend("0", 32);
        end if;
    end;
 end package body utils;