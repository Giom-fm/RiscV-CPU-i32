-- A module to compare two values. Used for the Branch Opcodes
-- Author: Guillaume Fournier-Mayer
-- Date: 09.05.2021


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;

entity comparator is
  port (
    -- The comparison mode to be applied
    i_comparator_mode : in T_COMP_MODE;
    -- The left operand (rs1)
    i_left : in std_logic_vector(31 downto 0);
    -- The right operand (rs2)
    i_right : in std_logic_vector(31 downto 0);
    -- The result of the operation
    o_result : out std_logic
  );
end comparator;

architecture a_comparator of comparator is

begin
  compare : process (i_comparator_mode, i_left, i_right) begin

    -- Default case
    o_result <= '0';

    case i_comparator_mode is
      -- Equal
      when COMP_EQUAL =>
        if unsigned(i_left) = unsigned(i_right) then
          o_result <= '1';
        end if;
      -- Not Equal
      when COMP_NOT_EQUAL =>
        if unsigned(i_left) /= unsigned(i_right) then
          o_result <= '1';
        end if;
      -- Less then
      when COMP_LESS_THEN =>
        if signed(i_left) < signed(i_right) then
          o_result <= '1';
        end if;
      -- Greater equal
      when COMP_GREATER_EQUAL =>
        if signed(i_left) >= signed(i_right) then
          o_result <= '1';
        end if;
      -- Less then (unsigned)
      when COMP_LESS_THEN_U =>
        if unsigned(i_left) < unsigned(i_right) then
          o_result <= '1';
        end if;
      -- Greater equal (unsigned)
      when COMP_GREATER_EQUAL_U =>
        if unsigned(i_left) >= unsigned(i_right) then
          o_result <= '1';
        end if;
    end case;
  end process;
end a_comparator;