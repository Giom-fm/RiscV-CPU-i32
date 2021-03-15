-- The module provides functions for recurring tasks
-- Author: Guillaume Fournier-Mayer

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

package utils is

  -- Fills up the upper remaining bits with zeros
  -- data: The data to be filled up
  -- length: The length to be filled up
  function extend(data : std_logic_vector; length : integer
  ) return std_logic_vector;

  -- Fills up the upper remaining bits with ones
  -- data: The data to be filled up
  -- length: The length to be filled up
  function extend_signed(data : std_logic_vector; length : integer
  ) return std_logic_vector;

  -- Converts a boolean value into a std_logic_vector
  function bool_to_word(bool : boolean
  ) return std_logic_vector;

end package utils;

package body utils is

  function extend(data : std_logic_vector; length : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(unsigned(data), length));
  end;

  function extend_signed(data : std_logic_vector; length : integer) return std_logic_vector is
  begin
    return std_logic_vector(resize(signed(data), length));
  end;

  function bool_to_word(bool : boolean) return std_logic_vector is
  begin
    if (bool) then
      return extend("1", 32);
    else
      return extend("0", 32);
    end if;
  end;
end package body utils;