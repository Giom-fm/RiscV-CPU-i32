/*
  Module for performing arithmetic, logical and shift operations
  Author : Guillaume Fournier - Mayer (tinf101922)
*/

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;
use work.types.all;
use work.utils.all;
entity alu is
  port (
    -- The operation to be processed 
    i_alu_mode : in T_ALU_MODE;
    -- The left operand (rs1)
    i_left : in std_logic_vector(31 downto 0);
    -- The right operand (rs2)
    i_right : in std_logic_vector(31 downto 0);
    -- The result of the operation
    o_result : out std_logic_vector(31 downto 0)
  );
end alu;

architecture a_alu of alu is
  signal res_add : std_logic_vector(31 downto 0);
begin
  calculation : process (i_alu_mode, i_left, i_right, res_add)
  begin
    res_add <= std_logic_vector(unsigned(i_left) + unsigned(i_right));
    case i_alu_mode is

        -- ALU is not used (default)
      when ALU_UNUSED => o_result <= (others => '0');

        -- Addition of left and right operand
      when ALU_ADD => o_result <= res_add;

        -- Even addition 
      when ALU_ADD_EVEN => o_result <= res_add(31 downto 1) & '0';

        -- Subtraction of right operand from left operand
      when ALU_SUB => o_result <= std_logic_vector(unsigned(i_left) - unsigned(i_right));

        -- Logical left shift of the left operand by the shift amount held in the lower 5 bits of the right operand
      when ALU_SLL => o_result <= std_logic_vector(shift_left(unsigned(i_left), to_integer(unsigned(i_right(4 downto 0)))));

        -- Logical right shift of the left operand by the shift amount held in the lower 5 bits of the right operand
      when ALU_SRL => o_result <= std_logic_vector(shift_right(unsigned(i_left), to_integer(unsigned(i_right(4 downto 0)))));

        -- Arithmetic right shift of the left operand by the shift amount held in the lower 5 bits of the right operand
      when ALU_SRA => o_result <= std_logic_vector(shift_right(signed(i_left), to_integer(signed(i_right(4 downto 0)))));

        -- Checks if the left operand is smaller than the right one  
      when ALU_SLT => o_result <= bool_to_word(signed(i_left) < signed(i_right));

        -- Checks if the left operand is smaller than the right one when both are treated as unsigned numbers 
      when ALU_SLTU => o_result <= bool_to_word(unsigned(i_left) < unsigned(i_right));

        -- Bitwise XOR on left and right operand 
      when ALU_XOR => o_result <= i_left xor i_right;

        -- Bitwise OR on left and right operand 
      when ALU_OR => o_result <= i_left or i_right;

        -- Bitwise AND on left and right operand 
      when ALU_AND => o_result <= i_left and i_right;
    end case;
  end process;
end a_alu;